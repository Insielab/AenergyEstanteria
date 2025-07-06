require 'csv'
require 'json'
require 'erb'
require 'fileutils'
require 'time'

# === DETECTAR TIPOS DE DOCUMENTO DISPONIBLES ===
tipos_disponibles = Dir.glob("geogenerator/procesadores/*.rb").map { |f| File.basename(f, ".rb") }

puts "¿Qué tipo de documento deseas construir?"
puts "Opciones disponibles: #{tipos_disponibles.join(', ')}"
print "Escribe el tipo exacto: "
tipo_documento = gets.chomp.strip.downcase

unless tipos_disponibles.include?(tipo_documento)
  puts "❌ Tipo de documento no válido."
  exit
end

# === CONFIGURACIÓN DE ARCHIVOS ===
archivo_csv = "geogenerator/datos/#{tipo_documento}.csv"
archivo_erb = "geogenerator/plantillas/#{tipo_documento}.erb"
archivo_procesador = "geogenerator/procesadores/#{tipo_documento}.rb"

# === CARGAR Y PROCESAR CSV ===
require_relative "./geogenerator/procesadores/#{tipo_documento}"
tabla_info = procesar_csv(archivo_csv)

@titulo = case tipo_documento
when "defunciones"
  "Defunciones históricas: Papalotla, Mazatecochco, Tenancingo y Santa Catarina Ayometla (1990–2020)"
when "censo_discapacidad"
  "Población con capacidades diferentes — Censo 2020"
when "alturas"
  "Altura topográfica del Municipio de Papalotla de Xicohténcatl"
else
  "Documento generado automáticamente"
end

@tipo_documento = tipo_documento
@labels_json = tabla_info[:labels_json]
@datasets_json = tabla_info[:datasets_json]
@tabla_html = tabla_info[:tabla_html]
@encabezados_html = tabla_info[:encabezados_html]

# === EJECUTAR CORE Y MOVER FICHA ===
puts "🔄 Generando metadatos manualmente con Aenergy Core..."
system("ruby aenergy_core.rb")

# Detectar última ficha
ficha_original = Dir.glob("fichas/*.json").max_by { |f| File.mtime(f) }

# Mover a carpeta geogenerator/fichas/
FileUtils.mkdir_p("geogenerator/fichas")
nuevo_path = "geogenerator/fichas/#{File.basename(ficha_original)}"
FileUtils.cp(ficha_original, nuevo_path)

@ficha_hash = JSON.parse(File.read(nuevo_path))

# === GENERAR HTML ===
folio = @ficha_hash["folio"]
salida_html = "geogenerator/output/#{folio}.html"
template = ERB.new(File.read(archivo_erb))
html_renderizado = template.result(binding)

FileUtils.mkdir_p("geogenerator/output")
File.write(salida_html, html_renderizado)

puts "✅ HTML generado: #{salida_html}"
puts "✅ Ficha movida desde core: #{nuevo_path}"

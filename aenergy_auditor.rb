require 'json'
require 'date'
require 'fileutils'

# Asegurar que las carpetas necesarias existen
Dir.mkdir('logs') unless Dir.exist?('logs')
Dir.mkdir('reportes') unless Dir.exist?('reportes')

# Inicializar contadores
total_fichas = 0
formatos = Hash.new(0)
anios = Hash.new(0)
categorias = Hash.new(0)
sin_url = 0
internos = 0
externos = 0

# Leer todos los JSON de la carpeta fichas
Dir.glob('fichas/*.json') do |file_path|
  begin
    ficha = JSON.parse(File.read(file_path))

    total_fichas += 1

    # Contar Formato
    formato = ficha["formato"] || "Desconocido"
    formatos[formato] += 1

    # Contar Año
    anio = ficha["anio"] || "Desconocido"
    anios[anio] += 1

    # Contar Categoría
    categoria = ficha["categoria"] || "Desconocida"
    categorias[categoria] += 1

    # Contar sin URL
    sin_url += 1 if ficha["url_azure_blob"].nil? || ficha["url_azure_blob"].strip.empty?

    # Contar tipo de almacenamiento
    almacenamiento = ficha["tipo_almacenamiento"] || "desconocido"
    if almacenamiento == "interno"
      internos += 1
    elsif almacenamiento == "externo"
      externos += 1
    end

  rescue JSON::ParserError => e
    puts "⚠️ Error leyendo #{file_path}: #{e.message}"
  end
end

# Fecha actual para nombres de archivos
timestamp = Time.now.utc.strftime("%Y%m%d-%H%M")

# Generar Reporte Markdown
reporte_md = <<~MARKDOWN
  # 📚 Reporte de Indexación - Proyecto Aenergy
  **Fecha de generación:** #{Time.now.utc}

  ---

  ## 📈 Resumen General
  - Total de archivos indexados: #{total_fichas}
  - Archivos sin URL en Azure o externos: #{sin_url}

  ## 🔐 Por Tipo de Almacenamiento
  - Internos (en Azure Blob): #{internos}
  - Externos (con URL): #{externos}

  ## 📚 Por Formato
  #{formatos.map { |formato, cantidad| "- #{formato}: #{cantidad}" }.join("\n")}

  ## 📅 Por Año de Publicación
  #{anios.map { |anio, cantidad| "- #{anio}: #{cantidad}" }.join("\n")}

  ## 🏷️ Por Categoría
  #{categorias.map { |categoria, cantidad| "- #{categoria}: #{cantidad}" }.join("\n")}

  ---

  _Aquí está tu reporte, de parte de **Proyecto Aenergy**._
MARKDOWN

# Guardar reporte en archivo .md
reporte_path = "reportes/reporte-#{timestamp}.md"
File.open(reporte_path, "w") { |file| file.write(reporte_md) }

# Loggear la generación de reporte
log_entry = "[#{Time.now.utc}] Reporte generado: #{reporte_path}\n"
File.open("logs/generacion_reportes.log", "a") { |file| file.write(log_entry) }

# Mostrar resumen en consola
puts "\n✅ Reporte generado exitosamente: #{reporte_path}"
puts "📄 Log actualizado en logs/generacion_reportes.log"

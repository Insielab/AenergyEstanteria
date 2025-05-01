require 'json'
require 'securerandom'
require 'date'
require 'time'

FORMATOS_VALIDOS = ['PDF', 'MD', 'HTML', 'JPG', 'MP3']

# Función para generar las iniciales del autor
def generar_iniciales(autor)
  autor.split.map { |palabra| palabra[0] }.join.upcase
end

# Función para generar el folio
def generar_folio(anio, autor, titulo, categoria_codigo)
  fecha_formateada = "#{anio}0101" # siempre 1 de enero para el folio
  iniciales = generar_iniciales(autor)
  palabra_titulo = titulo.split.first&.capitalize.to_s.gsub(/[^0-9A-Za-z]/, '')
  "#{fecha_formateada}-#{iniciales}-#{palabra_titulo}-#{categoria_codigo}"
end

# Función principal para generar la ficha completa
def generar_ficha
  puts "🖋️ Ingresar datos para generar la ficha de la Estantería Digital:"

  print "Autor: "
  autor = gets.chomp.strip
  autor = pedir_de_nuevo("Autor") if autor.empty?

  print "Título: "
  titulo = gets.chomp.strip
  titulo = pedir_de_nuevo("Título") if titulo.empty?

  print "Año de publicación (YYYY): "
  anio = gets.chomp.strip
  anio = pedir_de_nuevo("Año") if anio.empty?
  unless anio.match?(/^\d{4}$/)
    puts "⚠️ El año debe ser en formato YYYY. Inténtalo de nuevo."
    anio = pedir_de_nuevo("Año (formato YYYY)")
  end

  print "Categoría (nombre completo): "
  categoria = gets.chomp.strip
  categoria = pedir_de_nuevo("Categoría") if categoria.empty?

  print "Código corto de la categoría (ej: DH para Desarrollo Histórico): "
  categoria_codigo = gets.chomp.strip.upcase
  categoria_codigo = pedir_de_nuevo("Código corto de la categoría") if categoria_codigo.empty?

  # Seleccionar formato
  formato = seleccionar_formato

  # Verificar si el archivo es propietario
  puts "\n¿El archivo es de propiedad o licencia interna del proyecto? (sí/no)"
  propietario = gets.chomp.strip.downcase

  until ['sí', 'si', 'no'].include?(propietario)
    puts "⚠️ Responde solo 'sí' o 'no'."
    print "¿Es propietario? (sí/no): "
    propietario = gets.chomp.strip.downcase
  end

  tipo_almacenamiento = propietario.start_with?('s') ? "interno" : "externo"

  url_blob = nil
  if tipo_almacenamiento == "externo"
    puts "🔗 Al ser externo, se requiere una URL del recurso:"
    url_blob = pedir_de_nuevo("URL del archivo externo")
  else
    print "URL del archivo en Azure Blob (opcional): "
    url_blob = gets.chomp.strip
  end

  # Generar folio
  folio = generar_folio(anio, autor, titulo, categoria_codigo)

  # Crear ficha de metadatos
  ficha = {
    "folio" => folio,
    "autor" => autor,
    "titulo" => titulo,
    "anio" => anio,
    "categoria" => categoria,
    "codigo_categoria" => categoria_codigo,
    "formato" => formato,
    "tipo_almacenamiento" => tipo_almacenamiento,
    "url_azure_blob" => url_blob.empty? ? nil : url_blob,
    "creado_por" => "Proyecto aenergy",
    "fecha_de_registro" => Time.now.utc.iso8601,
    "descripcion" => "Ficha generada automáticamente para la Estantería Digital de Papalotla. Basada en entrada del usuario.",
    "version_ficha" => "1.3"
  }

  # Crear carpeta 'fichas' si no existe
  Dir.mkdir('fichas') unless Dir.exist?('fichas')

  # Guardar JSON
  ruta_archivo = "fichas/#{folio}.json"
  File.open(ruta_archivo, "w") { |file| file.write(JSON.pretty_generate(ficha)) }

  # Mostrar resumen en formato Markdown (solo en consola)
  puts "\n✅ Ficha creada exitosamente: #{ruta_archivo}"
  puts "\n📄 Resumen en formato Markdown:\n\n"
  puts "|Campo|Valor|"
  puts "|--|--|"
  puts "|**Título**|#{titulo}|"
  puts "|**Folio**|#{folio}|"
  puts "|**Año**|#{anio}|"
  puts "|**Categoría**|#{categoria}|"
  puts "|**Fecha de indexación**|#{ficha["fecha_de_registro"]}|"
  puts "|**Almacenamiento**|#{tipo_almacenamiento}|"
end

# Función para pedir de nuevo un campo vacío
def pedir_de_nuevo(campo)
  input = ""
  while input.strip.empty?
    print "#{campo} (no puede quedar vacío): "
    input = gets.chomp
  end
  input
end

# Función para seleccionar formato válido
def seleccionar_formato
  puts "\n📚 Selecciona el formato del archivo:"
  FORMATOS_VALIDOS.each_with_index do |formato, index|
    puts "#{index + 1}. #{formato}"
  end

  print "Escribe el número correspondiente: "
  seleccion = gets.chomp.to_i

  until seleccion.between?(1, FORMATOS_VALIDOS.length)
    puts "⚠️ Selección inválida. Intenta de nuevo."
    print "Escribe el número correspondiente: "
    seleccion = gets.chomp.to_i
  end

  FORMATOS_VALIDOS[seleccion - 1]
end

# Ejecutar el generador
generar_ficha

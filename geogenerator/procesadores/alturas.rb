require 'csv'

def procesar_csv(ruta_csv)
  datos = CSV.read(ruta_csv, headers: true)

  coordenadas = datos["Coordenadas"].to_a
  nombres = datos["Nombre"].to_a
  alturas = datos["Altura_msnm"].map { |v| v.to_s.gsub(',', '').to_i }

  # Tabla HTML
  tabla_html = ""
  datos.each do |row|
    tabla_html += "<tr><td>#{row['Coordenadas']}</td><td>#{row['Nombre']}</td><td>#{row['Altura_msnm']}</td></tr>\n"
  end

  # Encabezados
  encabezados_html = "<th>Coordenadas</th><th>Nombre</th><th>Altura (msnm)</th>"

  # ChartJS Dataset
  datasets_json = [{
    label: "Altura sobre el nivel del mar",
    data: alturas,
    backgroundColor: "#a78bfa"
  }].to_json

  labels_json = nombres.to_json

  {
    tabla_html: tabla_html,
    datasets_json: datasets_json,
    labels_json: labels_json,
    encabezados_html: encabezados_html
  }
end

require 'csv'

def procesar_csv(ruta_csv)
  datos = CSV.read(ruta_csv, headers: true)
  anios = datos["Año"].to_a
  municipios = datos.headers[1..-1]
  valores = {}

  municipios.each do |mun|
    valores[mun] = datos[mun].map { |x| x.to_i rescue 0 }
  end

  tabla_html = ""
  datos.each do |row|
    fila = "<tr><td>#{row['Año']}</td>"
    municipios.each { |m| fila += "<td>#{row[m]}</td>" }
    fila += "</tr>\n"
    tabla_html += fila
  end

  encabezados_html = municipios.map { |m| "<th>#{m}</th>" }.join

  datasets_json = municipios.map do |mun|
    {
      label: mun,
      data: valores[mun],
      fill: false
    }
  end.to_json

  labels_json = anios.map(&:to_s).to_json

  {
    tabla_html: tabla_html,
    datasets_json: datasets_json,
    labels_json: labels_json,
    encabezados_html: encabezados_html
  }
end

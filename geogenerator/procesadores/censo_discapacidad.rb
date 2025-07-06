require 'csv'

def procesar_csv(ruta_csv)
  datos = CSV.read(ruta_csv, headers: true)

  localidades = datos["NOM_LOC"].to_a
  campos_interes = ["PCON_DISC", "PCDISC_MOT", "PCDISC_VIS", "PCDISC_LENG", "PCDISC_AUD"]

  valores = {}
  campos_interes.each do |campo|
    valores[campo] = []
  end

  localidades.each_with_index do |loc, i|
    campos_interes.each do |campo|
      valor = datos[i][campo]
      valores[campo] << (valor == "*" ? 0 : valor.to_i)
    end
  end

  # Preparar HTML para tabla
  encabezados_html = campos_interes.map { |m| "<th>#{m}</th>" }.join
  tabla_html = ""
  localidades.each_with_index do |loc, i|
    fila = "<tr><td>#{loc}</td>"
    campos_interes.each { |campo| fila += "<td>#{valores[campo][i]}</td>" }
    fila += "</tr>\n"
    tabla_html += fila
  end

  # Preparar datasets para gráfico
  datasets_json = campos_interes.map do |campo|
    {
      label: campo,
      data: valores[campo],
      fill: false
    }
  end.to_json

  labels_json = localidades.map(&:to_s).to_json

  {
    tabla_html: tabla_html,
    datasets_json: datasets_json,
    labels_json: labels_json,
    encabezados_html: encabezados_html
  }
end

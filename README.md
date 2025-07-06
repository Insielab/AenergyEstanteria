# Aenergy v.1.2

---

## Declaración Inicial

**Aenergy** es el motor digital desarrollado por **Insielab** para la **Estantería Digital de Papalotla**.

Su propósito es **preservar, organizar y dar vida a la memoria histórica y cultural de Papalotla**, convirtiendo documentos físicos, datos estadísticos y registros comunitarios en archivos digitales normalizados y visualizaciones interactivas.

Aunque hoy opera principalmente en back office, Aenergy está diseñado para convertirse en **la base tecnológica visible de la Estantería Digital**, accesible a toda la comunidad.

---

## Qué es Aenergy

Aenergy es un proyecto Ruby compuesto por tres grandes módulos:

✅ **Core (aenergy_core.rb)**  
- Solicita datos interactivamente.  
- Genera fichas JSON con metadatos normalizados.  
- Guarda las fichas en `/fichas`.  
- Muestra un resumen en consola en formato Markdown.

✅ **Auditor (aenergy_auditor.rb)**  
- Lee todas las fichas JSON.  
- Genera reportes consolidados en Markdown.  
- Cuenta:
  - Total de fichas.
  - Distribución por año, formato, categoría.
  - Internos vs. externos.
- Guarda los reportes en `/reportes` y registra logs en `/logs`.

✅ **Geogenerator (aenergy_geo.rb)**  
- Procesa datos CSV y plantillas ERB.  
- Ejecuta el core para generar la ficha JSON.  
- Mueve la ficha generada a `/geogenerator/fichas`.  
- Renderiza HTML dinámico en `/geogenerator/output`.

---

## Requisitos

- Ruby >= 2.7

### Gems utilizadas:
- json
- csv
- erb
- fileutils
- date
- time
- securerandom

*(Todas forman parte de la biblioteca estándar de Ruby.)*

---

## Estructura de Carpetas

```
Insielab/
├── fichas/
│     └── *.json
├── logs/
│     └── generacion_reportes.log
├── reportes/
│     └── reporte-YYYYMMDD-HHMM.md
├── geogenerator/
│     ├── datos/
│     │     └── *.csv
│     ├── fichas/
│     │     └── *.json
│     ├── output/
│     │     └── *.html
│     ├── plantillas/
│     │     └── *.erb
│     └── procesadores/
│           └── *.rb
├── aenergy_core.rb
├── aenergy_auditor.rb
├── aenergy_geo.rb
└── README.md
```

---

## Cómo usar Aenergy

### 1. Generar una ficha JSON (Core)

Ejecuta:

```
ruby aenergy_core.rb
```

- Te pedirá los datos uno a uno.
- Guardará el JSON en `/fichas/`.
- Mostrará un resumen Markdown en consola.

---

### 2. Auditar fichas existentes

Ejecuta:

```
ruby aenergy_auditor.rb
```

- Generará un reporte en Markdown en `/reportes/`.
- Registrará logs en `/logs/`.

---

### 3. Generar un documento HTML (Geogenerator)

Ejecuta:

```
ruby aenergy_geo.rb
```

- Te pedirá qué tipo de documento quieres generar.
- Procesará el CSV correspondiente.
- Ejecutará el core automáticamente.
- Moverá la ficha a `/geogenerator/fichas/`.
- Creará un archivo HTML dinámico en `/geogenerator/output/`.

---

## Ejemplo de flujo completo

1. Ejecutas `ruby aenergy_core.rb` y generas una ficha JSON:
```
/fichas/20220101-ML-Historia-HR.json
```

2. Ejecutas `ruby aenergy_auditor.rb` y obtienes un reporte:
```
/reportes/reporte-20250706-1445.md
```

3. Ejecutas `ruby aenergy_geo.rb` y produces:
```
/geogenerator/output/20220101-ML-Historia-HR.html
```

---

## Notas

- Las carpetas `fichas/`, `logs/`, `reportes/`, y todas las subcarpetas de `geogenerator/` se crean automáticamente si no existen.
- El nombre del archivo de reporte incluye la fecha y hora UTC.
- Los folios siempre usan el patrón `YYYY0101` (1 de enero) para estandarizar claves.
- Si un archivo es externo, se solicita obligatoriamente la URL.

---

## Autor

Desarrollado en Papalotla de Xicohténcatl, Tlaxcala, México por:
**Estantería Digital de Papalotla**
**Insielab**  


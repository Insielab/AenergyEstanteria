# aenergy_core.rb - Proyecto Aenergy v1.0

---

## Descripción

**aenergy_core.rb** es el núcleo del proyecto Aenergy, desarrollado por **Insielab** para la **Estantería Digital de Papalotla**. Su función principal es **crear fichas JSON estandarizadas** a partir de datos ingresados por el usuario, que servirán como registros digitales de documentos, imágenes, audios y otros materiales.

Cada ficha generada contiene metadatos esenciales para organizar y preservar la memoria histórica y cultural de Papalotla.

---

## Características

- Solicita interactivamente:
  - Autor
  - Título
  - Año de publicación
  - Categoría (nombre completo)
  - Código corto de la categoría
  - Formato del archivo (PDF, MD, HTML, JPG, MP3)
  - Tipo de almacenamiento (interno o externo)
  - URL del archivo si es externo

- Genera:
  - **Folio único** basado en:
    - Año
    - Iniciales del autor
    - Primera palabra del título
    - Código corto de la categoría

- Crea un archivo JSON estructurado con todos los metadatos.

- Muestra un resumen en consola en formato Markdown.

- Guarda cada ficha JSON en la carpeta:
```
/fichas
```

---

## Requisitos

- Ruby >= 2.7

### Gems utilizadas:
- json
- securerandom
- date
- time

---

## Cómo usarlo

Ejecuta el script directamente en terminal:

```
ruby aenergy_core.rb
```

Se solicitarán los datos uno por uno. Al finalizar:

- Se creará un archivo JSON en:
```
/fichas/{folio}.json
```

- Se imprimirá un resumen en consola en forma de tabla Markdown.

---

## Ejemplo de ejecución

### Datos de entrada:

```
Autor: María López
Título: Historia de Papalotla
Año de publicación (YYYY): 2022
Categoría (nombre completo): Historia Regional
Código corto de la categoría (ej: DH): HR
Formato del archivo: PDF
¿El archivo es de propiedad o licencia interna del proyecto? (sí/no): no
URL del archivo externo: https://mipapalotla.com/docs/historia.pdf
```

### Resultado:

- Archivo generado:
```
/fichas/20220101-ML-Historia-HR.json
```

- Resumen mostrado en consola:

```
|Campo|Valor|
|--|--|
|**Título**|Historia de Papalotla|
|**Folio**|20220101-ML-Historia-HR|
|**Año**|2022|
|**Categoría**|Historia Regional|
|**Fecha de indexación**|2025-07-06T14:20:58Z|
|**Almacenamiento**|externo|
```

---

## Formatos válidos

- PDF
- MD
- HTML
- JPG
- MP3

---

## Estructura del JSON generado

Ejemplo de salida:

```json
{
  "folio": "20220101-ML-Historia-HR",
  "autor": "María López",
  "titulo": "Historia de Papalotla",
  "anio": "2022",
  "categoria": "Historia Regional",
  "codigo_categoria": "HR",
  "formato": "PDF",
  "tipo_almacenamiento": "externo",
  "url_azure_blob": "https://mipapalotla.com/docs/historia.pdf",
  "creado_por": "Proyecto aenergy",
  "fecha_de_registro": "2025-07-06T14:20:58Z",
  "descripcion": "Ficha generada automáticamente para la Estantería Digital de Papalotla. Basada en entrada del usuario.",
  "version_ficha": "1.3"
}
```

---

## Notas

- Los folios siempre generan la fecha como `YYYY0101` (1 de enero) para mantener consistencia en el patrón.
- Si el archivo es externo, **la URL es obligatoria**.
- La versión actual es **1.3**.

---

## Autor

Desarrollado por:
**Insielab**  
Papalotla de Xicohténcatl, Tlaxcala, México

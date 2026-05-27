# Análisis de ventas de videojuegos (1980–2016)

> Read this in [English](./README.md)

🌐 **[Ver este proyecto online](https://alvaro-larry.github.io/Portfolio/projects/proyecto-1/)** · 📂 [Carpeta del proyecto en GitHub](https://github.com/alvaro-larry/Portfolio/tree/main/projects/proyecto-1) · 🏠 [Portfolio principal](https://alvaro-larry.github.io/Portfolio/)

Análisis orientado a la decisión sobre el mercado global de videojuegos: **¿en qué juego habría apostado un publisher de tamaño medio en 2016, y por qué?** Proyecto end-to-end desde el CSV en bruto, pasando por limpieza y análisis en SQL, hasta un dashboard interactivo en Power BI. **16.712 títulos · ~8.918M de unidades vendidas a nivel mundial · mercados NA / EU / JP / Resto.**

---

## El encargo

Imagina que es finales de 2016 y diriges un publisher de videojuegos de tamaño medio, con presupuesto para apostar por un gran lanzamiento en los próximos 2-3 años. ¿Por dónde apuestas?

Este análisis trata los 16.712 títulos históricos del dataset como evidencia para informar cinco decisiones comerciales concretas:

| # | Decisión | Qué necesitamos saber |
|---|---|---|
| 1 | **Género** | ¿Qué género maximiza las ventas esperadas para nuestro perfil de riesgo? |
| 2 | **Plataforma** | ¿Dónde publicamos — y en cuántas plataformas? |
| 3 | **Región** | ¿Para quién diseñamos primero: NA/EU, Japón, o todas las regiones? |
| 4 | **Rating ESRB** | ¿A qué franja de edad apuntamos? |
| 5 | **Inversión en calidad y prensa** | ¿Cuánto destinamos a polish y a cobertura mediática? |

La metodología explica cómo se preparó y exploró el dato; la sección de **recomendaciones** traduce los patrones en un plan de acción concreto.

---

## Dataset

- **Fuente:** [Video Game Sales with Ratings](https://www.kaggle.com/datasets/rush4ratio/video-game-sales-with-ratings) (Kaggle)
- **Tamaño original:** 16.719 filas × 16 columnas
- **Tras la limpieza:** 16.712 filas
- **Cobertura:** 1980–2016, ventas en NA / EU / JP / Resto del mundo (millones de unidades)
- **Campos de calidad:** puntuaciones de crítica (Metacritic), puntuaciones de usuario, número de reviews, clasificación ESRB

---

## Herramientas y tecnologías

| Capa | Herramienta |
|---|---|
| Base de datos | SQLite |
| Análisis | SQL (dialecto SQLite) |
| Visualización | Power BI |
| Exploración auxiliar | Excel |
| Control de versiones | Git / GitHub |

---

## Estructura del repositorio

```
proyecto-1/
├── data/
│   ├── raw/                               CSV original de Kaggle
│   ├── processed/videogames_final.csv     Datos limpios y tipados
│   └── videogames.db                      Base de datos SQLite
├── sql/
│   ├── videogames_cleaning.sql            Pipeline de limpieza
│   └── videogames_analysis.sql            Consultas analíticas (6 partes)
├── excel/
│   └── videogame_analysis.xlsx            Libro de exploración en Excel
├── powerbi/
│   ├── Video Games Market Analysis.pbix   Dashboard de Power BI (fuente)
│   └── Video Games Market Analysis.pdf    Exportación del dashboard en PDF
└── README.md
```

---

## Metodología

### 1. Limpieza — [`sql/videogames_cleaning.sql`](./sql/videogames_cleaning.sql)

- Identificación de las columnas con nulos: `Year_of_Release`, `Critic_Score`, `Critic_Count`, `User_Score`, `User_Count`, `Developer`, `Rating`.
- Borrado únicamente de filas con nulos en columnas **críticas** (`Name`, `Genre`, `Publisher`) — 2 filas en total.
- Sustitución del string `'tbd'` en `User_Score` por `NULL` real.
- Normalización de clasificaciones ESRB antiguas (`K-A`, `EC` → `E`).
- Eliminación de 4 filas con años de lanzamiento inválidos (2017, 2020) — el dataset está datado a diciembre de 2016.
- Detección y resolución de un duplicado de Madden NFL 13 (PS3, ventas mal registradas).
- Conversión de las columnas numéricas a tipos `REAL` / `INTEGER` en una nueva tabla `videogames_final`.
- ~40% de las filas tienen `Developer` nulo — se mantiene como campo secundario en lugar de descartarlo.

### 2. Análisis — [`sql/videogames_analysis.sql`](./sql/videogames_analysis.sql)

Seis partes temáticas, con interpretación en lenguaje natural anotada en cada consulta:

1. **Contexto de mercado** — totales, evolución, mayores éxitos de la historia, juego más vendido por año.
2. **Factores estructurales de éxito** — rankings de géneros / plataformas / publishers (totales, número, ventas medias), correlación con la puntuación de crítica y de usuario.
3. **Análisis regional** — desglose por NA / EU / JP / Resto.
4. **Análisis temporal** — evolución de géneros año a año, dominancia de plataformas por década.
5. **Análisis avanzado** — gap entre ranking por media y por total, efecto del número de reviews, discrepancia crítica–usuario, calidad por publisher, top 30 por género, índice Calidad–Ventas.
6. **Análisis de rating** — distribución, ventas por rating ESRB, cruces género/rating.

### 3. Visualización — [`powerbi/`](./powerbi/)

Dashboard de Power BI construido sobre los datos limpios que resume los hallazgos anteriores para un público no técnico. Consulta [`Video Games Market Analysis.pdf`](./powerbi/Video%20Games%20Market%20Analysis.pdf) para una vista previa estática.

---

## Hallazgos clave

Lo que muestra el dato, antes de extraer conclusiones comerciales. Las recomendaciones de la sección siguiente parten de aquí.

**Tamaño y forma del mercado**

- Ventas globales registradas: **8.917,52M de unidades** en **16.712 títulos**.
- Reparto regional: **NA 49,4% · EU 27,2% · JP 14,6% · Resto 8,9%**.
- La industria alcanzó su pico en **2008** tanto en lanzamientos como en ventas globales; la caída posterior es en parte real y en parte un artefacto del corte temporal del dataset (los juegos más recientes han tenido menos tiempo para acumular ventas).

**Qué vende**

- **Wii Sports** es el mayor éxito de todos los tiempos (82,5M de unidades), seguido de **GTA V** (56,6M) y **Super Mario Bros.** (45,3M).
- **Action** lidera en volumen total; **Platform** tiene el *techo* más alto (los mejores títulos de Mario / Donkey Kong superan en ventas al mejor juego de cualquier otro género).
- Entre las consolas de sobremesa de mediana edad, **PS2, X360, PS3 y Wii** dominan en ventas totales; **PS4** es la apuesta "reciente" más sólida en ventas medias por juego.
- **Nintendo** promedia **2,77M de unidades por juego** — con diferencia, lo más alto entre publishers grandes.

**Crítica vs. usuario**

- La puntuación de la crítica correlaciona **más fuerte** con las ventas que la puntuación de usuario.
- Los juegos con 40+ reviews de crítica venden de media **1,55M de unidades** — aproximadamente **6×** más que los que tienen menos de 10 reviews (mezcla de efecto cobertura mediática + proxy del tamaño del publisher).
- Cuando la crítica puntúa más alto que los usuarios, las ventas medias llegan a 1,28M. Cuando los usuarios puntúan más alto que la crítica, caen a 0,31M — sobre todo porque ese segmento captura juegos que a la crítica no le gustaron.

**Preferencias regionales**

- **NA / EU** comparten un perfil parecido: dominan *Action, Sports, Shooter*.
- **Japón** es estructuralmente distinto: lidera **Role-Playing**, las portátiles de Nintendo (DS, 3DS, SNES, NES) superan a las consolas de sobremesa, y los juegos de Pokémon ocupan las primeras posiciones.

**Ratings ESRB**

- **E** domina en volumen (~40% de los títulos), pero los juegos **M** tienen las ventas medias más altas (0,94M) — empujados por las franquicias GTA y Call of Duty. El contenido para adultos *no* perjudica al rendimiento comercial.

---

## Recomendaciones (a fecha de 2016)

Cada recomendación responde a una decisión del encargo, se apoya en los hallazgos anteriores y está dimensionada a lo que un publisher mediano podría realmente ejecutar.

### 1. Género — Platform o Shooter para perfil conservador; Action o Sports para apuesta de peso.

**Por qué.** Action y Sports dominan en volumen total, pero el mercado está saturado de títulos mediocres: ganar ahí exige ejecución de primer nivel. Platform tiene el *techo* más alto por juego (Mario, Donkey Kong superan a los mejores de cualquier otro género), pero el segmento es pequeño. Shooter ofrece el mejor equilibrio entre ventas medias y volumen total. Evitar Adventure y Strategy: estructuralmente bajo techo *y* bajo volumen.

### 2. Plataforma — PS4 como apuesta principal, con port a PS3/X360 si el presupuesto lo permite.

**Por qué.** PS4 tiene las mejores ventas medias por juego entre las plataformas nuevas; sus rivales de la misma generación (Wii U, Vita) son comercialmente débiles. PS3 y X360 son maduras pero todavía rentables. Evitar exclusivos a Wii / Wii U: la línea de sobremesa de Nintendo está en clara decadencia en 2016. Si se va a portátil, limitarla a 3DS, y solo si el juego encaja en el catálogo Nintendo.

### 3. Región — Diseñar primero para Norteamérica y Europa.

**Por qué.** NA (49,4%) + EU (27,2%) representan el **~76% de las ventas globales** y comparten preferencias (Action, Sports, Shooter). Japón es estructuralmente distinto: prefiere Role-Playing, portátiles Nintendo y Pokémon — y representa solo el 14,6% de las ventas. Apuntar a Japón primero tiene sentido comercial solo si el estudio tiene ADN creativo japonés (Capcom, Bandai Namco, Square Enix).

### 4. Rating ESRB — M para Action/Shooter; E para Platform/Sports. Evitar T como objetivo.

**Por qué.** Los juegos M tienen las **ventas medias más altas** (0,94M de unidades), empujados por GTA y Call of Duty — el contenido adulto no perjudica al rendimiento comercial, correlaciona con él. E domina en volumen total pero es el mercado de masas saturado. T queda en lo peor de los dos mundos: menos ventas medias que M, sin ventaja clara sobre E.

### 5. Calidad y prensa — Apuntar a Critic Score ≥ 80; invertir en relaciones con prensa desde el inicio.

**Por qué.** La puntuación de crítica correlaciona con ventas mucho más fuerte que la de usuario. Los juegos con **40+ reviews de crítica venden de media 6× más** que los que tienen menos de 10 — señal de que cobertura mediática y tamaño de publisher se acumulan. Para un publisher pequeño, esto significa que copias para reviewers, eventos de preview y relaciones con prensa especializada no son gasto opcional: son la palanca.

**Insight extra (y un aviso).** No optimizar por puntuación de usuario. Cuando la crítica puntúa más alto que los usuarios, las ventas medias llegan a 1,28M. Cuando los usuarios puntúan más alto que la crítica, las ventas caen a 0,31M. El segmento "users-higher" captura sobre todo juegos que a la crítica no le gustaron, que el mercado general luego ignora independientemente de la opinión de los usuarios. La crítica conduce la decisión de compra; los usuarios reaccionan después.

---

## Cómo explorar el proyecto

- **Ver el dashboard (estático)** → abre [`powerbi/Video Games Market Analysis.pdf`](./powerbi/Video%20Games%20Market%20Analysis.pdf)
- **Ver el dashboard (interactivo)** → abre [`powerbi/Video Games Market Analysis.pbix`](./powerbi/Video%20Games%20Market%20Analysis.pbix) en Power BI Desktop
- **Reproducir la limpieza + análisis** → carga `data/videogames.db` en cualquier cliente SQLite (DBeaver, `sqlite3` CLI, DB Browser) y ejecuta los scripts de `sql/` en orden: limpieza → análisis.
- **Consultar el dataset limpio** → [`data/processed/videogames_final.csv`](./data/processed/videogames_final.csv)

---

## Limitaciones

- El dataset termina en **diciembre de 2016**; los lanzamientos modernos (a partir del ciclo medio de PS4) no están representados.
- **Los datos faltantes se concentran en los campos de calidad.** La cobertura varía mucho entre columnas:

  | Campo | Cobertura | % nulos |
  |---|---:|---:|
  | `Name`, `Platform`, `Genre`, `Publisher`, `Global_Sales` | 16.712 / 16.712 | 0% |
  | `Year_of_Release` | 16.443 / 16.712 | 1,6% |
  | `Developer` | 10.094 / 16.712 | 39,6% |
  | `Rating` | 9.948 / 16.712 | 40,5% |
  | `Critic_Score`, `Critic_Count` | 8.136 / 16.712 | 51,3% |
  | `User_Score`, `User_Count` | 7.589 / 16.712 | 54,6% |

  Cualquier análisis que use puntuaciones, ratings o información de desarrollador está necesariamente condicionado a la disponibilidad del campo — **más de la mitad** del catálogo carece de datos de Metacritic, mayormente títulos antiguos, lanzamientos de nicho y juegos en plataformas con poca cobertura mediática.
- `User_Score` y `Critic_Score` vienen de Metacritic y heredan sus sesgos de selección (puntúan los fans más fieles; el público mainstream no suele puntuar).
- Las ventas están en **unidades distribuidas (sell-in)**, no en facturación.

---

## Autor

**Álvaro Larriba Rius** — Analista de datos con formación en el Doble Grado de Física y Matemáticas.
Madrid, España.

- Email: alvarolarriba@gmail.com
- LinkedIn: [Álvaro Larriba Rius](https://www.linkedin.com/in/alvaro-larriba-ab62903aa)
- GitHub: [@alvaro-larry](https://github.com/alvaro-larry)
- Portfolio: [alvaro-larry.github.io/Portfolio](https://alvaro-larry.github.io/Portfolio/) · [Repositorio](https://github.com/alvaro-larry/Portfolio)

---

*Parte de [mi portfolio de análisis de datos](https://alvaro-larry.github.io/Portfolio/). Proyecto 1 de una serie en crecimiento.*

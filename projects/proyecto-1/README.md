# Video Game Sales Analysis (1980–2016)

> Read this in [Spanish / Español](./README.es.md)

End-to-end exploratory data analysis of the global video game market — from raw CSV to a cleaned SQL database to an interactive Power BI dashboard. **16,712 titles · ~8,918M units sold globally · NA / EU / JP / Other markets.**

---

## Overview

This project takes a public dataset of video game sales (Kaggle, ~16,700 titles released between 1980 and 2016) and turns it into a structured analysis answering one question: **what makes a video game commercially successful?**

The work is split into three layers:

1. **Cleaning in SQL** — null handling, type casting, deduplication, value normalisation (`'tbd'` → `NULL`, `K-A`/`EC` → `E`, etc.).
2. **Analytical SQL** — 6 thematic blocks: market context, structural factors of success, regional patterns, temporal evolution, advanced cross-cuts, and rating analysis.
3. **Visualisation in Power BI + Excel** — interactive dashboard summarising the findings for a non-technical audience.

---

## Dataset

- **Source:** [Video Game Sales with Ratings](https://www.kaggle.com/datasets/rush4ratio/video-game-sales-with-ratings) (Kaggle)
- **Original size:** 16,719 rows × 16 columns
- **After cleaning:** 16,712 rows
- **Coverage:** 1980–2016, sales in NA / EU / JP / Other (millions of units)
- **Quality fields:** Metacritic critic scores, user scores, critic/user counts, ESRB ratings

---

## Tools & technologies

| Layer | Tool |
|---|---|
| Database | SQLite |
| Analysis | SQL (SQLite dialect) |
| Visualisation | Power BI |
| Aux. exploration | Excel |
| Versioning | Git / GitHub |

---

## Repository structure

```
proyecto-1/
├── data/
│   ├── raw/                               Original CSV from Kaggle
│   ├── processed/videogames_final.csv     Cleaned & typed output
│   └── videogames.db                      SQLite database
├── sql/
│   ├── videogames_cleaning.sql            Cleaning pipeline
│   └── videogames_analysis.sql            Analytical queries (6 parts)
├── excel/
│   └── videogame_analysis.xlsx            Exploratory Excel workbook
├── powerbi/
│   ├── Video Games Market Analysis.pbix   Power BI dashboard (source)
│   └── Video Games Market Analysis.pdf    PDF export of the dashboard
└── README.md
```

---

## Methodology

### 1. Cleaning — [`sql/videogames_cleaning.sql`](./sql/videogames_cleaning.sql)

- Identified null-rich columns: `Year_of_Release`, `Critic_Score`, `Critic_Count`, `User_Score`, `User_Count`, `Developer`, `Rating`.
- Deleted only rows with nulls in **critical** columns (`Name`, `Genre`, `Publisher`) — 2 rows in total.
- Replaced `'tbd'` strings in `User_Score` with proper `NULL`s.
- Normalised legacy ESRB ratings (`K-A`, `EC` → `E`).
- Removed 4 rows with invalid release years (2017, 2020) — the dataset is dated December 2016.
- Detected and resolved one Madden NFL 13 duplicate (PS3, mis-recorded sales).
- Cast numeric columns to proper `REAL` / `INTEGER` types into a new `videogames_final` table.
- ~40% of rows have a NULL `Developer` — kept as a secondary field rather than dropped.

### 2. Analysis — [`sql/videogames_analysis.sql`](./sql/videogames_analysis.sql)

Six thematic parts, every query annotated with plain-English interpretation:

1. **Market context** — totals, evolution over time, all-time best sellers, year-by-year #1.
2. **Structural factors of success** — genre / platform / publisher rankings (total, count, average sales), correlation with critic and user scores.
3. **Regional analysis** — NA / EU / JP / Other breakdowns.
4. **Temporal analysis** — genre evolution year by year, platform dominance by decade.
5. **Advanced analysis** — avg-vs-total rank gap, review-count effects, critic–user discrepancy, publisher quality, top-30 by genre, custom Quality–Sales index.
6. **Rating analysis** — distribution, sales by ESRB rating, genre/rating cross-tabs.

### 3. Visualisation — [`powerbi/`](./powerbi/)

A Power BI dashboard built on the cleaned dataset, summarising the findings above for stakeholders. See [`Video Games Market Analysis.pdf`](./powerbi/Video%20Games%20Market%20Analysis.pdf) for a static preview.

---

## Key findings

**Market size & shape**

- Global sales recorded: **8,917.52M units** across **16,712 titles**.
- Regional split: **NA 49.4% · EU 27.2% · JP 14.6% · Other 8.9%**.
- The industry peaked in **2008** in both releases and global sales; the post-2008 decline is partly real and partly a dataset truncation artefact (newer games had less time to accumulate sales).

**What sells**

- **Wii Sports** is the all-time best seller (82.5M units), followed by **GTA V** (56.6M) and **Super Mario Bros.** (45.3M).
- **Action** leads by total volume; **Platform** has the highest *ceiling* (the best Mario / Donkey Kong titles outsell the best of any other genre).
- Among middle-aged home consoles, **PS2, X360, PS3 and Wii** dominate total sales; **PS4** is the strongest "newer" bet on average sales per game.
- **Nintendo** averages **2.77M units per game** — by far the highest of any major publisher.

**Critic vs. user scores**

- Critic scores correlate **more strongly** with sales than user scores do.
- Games with 40+ critic reviews average **1.55M units** — roughly **6×** more than games with fewer than 10 reviews (a mix of media-coverage effect and publisher-size proxy).
- When critics score higher than users, average sales peak at 1.28M. When users score higher than critics, average sales drop to 0.31M — mostly because that segment captures games critics disliked.

**Regional preferences**

- **NA / EU** share a similar profile: *Action, Sports, Shooter* dominate.
- **Japan** is structurally different: **Role-Playing** leads, Nintendo handhelds (DS, 3DS, SNES, NES) outsell home consoles, and Pokémon titles take the top spots.

**ESRB ratings**

- **E** dominates by volume (~40% of titles), but **M-rated** games have the highest average sales (0.94M) — driven by the GTA and Call of Duty franchises. Mature content does *not* hurt commercial performance.

---

## How to explore the project

- **View the dashboard (static)** → open [`powerbi/Video Games Market Analysis.pdf`](./powerbi/Video%20Games%20Market%20Analysis.pdf)
- **View the dashboard (interactive)** → open [`powerbi/Video Games Market Analysis.pbix`](./powerbi/Video%20Games%20Market%20Analysis.pbix) in Power BI Desktop
- **Reproduce the cleaning + analysis** → load `data/videogames.db` in any SQLite client (DBeaver, `sqlite3` CLI, DB Browser) and run the scripts in `sql/` in order: cleaning → analysis.
- **Browse the cleaned dataset** → [`data/processed/videogames_final.csv`](./data/processed/videogames_final.csv)

---

## Limitations

- The dataset ends in **December 2016**; modern releases (post-PS4 lifecycle) are not represented.
- **Missing data is concentrated in the quality fields.** Coverage varies dramatically across columns:

  | Field | Coverage | Null rate |
  |---|---:|---:|
  | `Name`, `Platform`, `Genre`, `Publisher`, `Global_Sales` | 16,712 / 16,712 | 0% |
  | `Year_of_Release` | 16,443 / 16,712 | 1.6% |
  | `Developer` | 10,094 / 16,712 | 39.6% |
  | `Rating` | 9,948 / 16,712 | 40.5% |
  | `Critic_Score`, `Critic_Count` | 8,136 / 16,712 | 51.3% |
  | `User_Score`, `User_Count` | 7,589 / 16,712 | 54.6% |

  Any analysis using scores, ratings or developer information is necessarily conditional on availability — **more than half** of the catalogue lacks Metacritic data, mostly older titles, niche releases and games on platforms with limited press coverage.
- `User_Score` and `Critic_Score` come from Metacritic and inherit its selection biases (dedicated fans rate; mainstream players often don't).
- Sales are measured in **units shipped**, not in revenue.

---

## Author

**Álvaro Larriba Rius** — Data analyst with a background in the Double Degree in Physics & Mathematics.
Madrid, Spain.

- Email: alvarolarriba@gmail.com
- LinkedIn: [Álvaro Larriba Rius](https://www.linkedin.com/in/alvaro-larriba-ab62903aa)
- GitHub: [@alvaro-larry](https://github.com/alvaro-larry)
- Portfolio: see [the main README](../../README.md)

---

*Part of [my data analysis portfolio](../../README.md). Project 1 of a growing series.*

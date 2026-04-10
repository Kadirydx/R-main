# MTT Assay Data Analysis & Visualization App 

## About the Project
This interactive web application is built with R and Shiny to streamline the processing, visualization, and analysis of MTT cell viability assay data. Designed for laboratory researchers, the app allows users to seamlessly upload raw Excel data files, assign experimental metadata (e.g., specific time points like 24H, 48H, 72H), and interactively manage well conditions. A core strength of this application is its automated quality control, instantly identifying and visually flagging outlier wells to ensure robust experimental results.

##  Technologies Used
* **R & Shiny:** Core framework for building the interactive web application UI and server logic.
* **rhandsontable & JavaScript:** Rendering interactive, Excel-like data grids directly in the browser with custom cell styling.
* **readxl:** Parsing and extracting raw absorbance data directly from user-uploaded Excel (`.xlsx`) spreadsheets.
* **jsonlite:** Bridging R data structures with JavaScript arrays for dynamic UI updates.

##  Key Features
* **Dynamic Data Import:** A dedicated "Form" module that accepts `.xlsx` uploads and ties them to specific experimental metadata (MTT Number, Date, and Incubation Hour).
* **Interactive Outlier Detection:** Utilizes custom JavaScript renderers within `rhandsontable` to automatically calculate, locate, and visually highlight outlier wells (e.g., turning cell backgrounds salmon/red) directly on the grid.
* **Time-Course Tracking:** Ability to filter and review specific MTT runs that have completed all 3 essential time points.
* **Condition Mapping:** Features a dedicated module and dynamic UI grid to map specific experimental conditions to plate layouts.
* **Modular Architecture:** The backend logic relies on custom, modularized functions (e.g., `extract_abs_data.R`, `get_outlier_mask.R`) for maintainable and clean code.

# dev notes: need to improve..
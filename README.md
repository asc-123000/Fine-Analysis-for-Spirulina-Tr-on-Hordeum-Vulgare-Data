# Spirulina Treatment on Barley - Scientific Visualization Analysis

## Overview

This analysis generates **publication-quality exploratory barplots** for the Spirulina treatment experiment on barley (*Hordeum vulgare*) cultivars. The visualization preserves all biological sample identity and provides clear comparative analysis between control and treatment groups across five cultivars and two timepoints.

---

## Project Structure

```
Spirulina tr. on Hordeum vulgare/
├── Data of timepoint 1.xlsx          # Raw experimental data (T1)
├── Data of timepoint 2.xlsx          # Raw experimental data (T2)
├── spirulina_barplot_analysis.R      # Main analysis script
├── README.md                          # This file
└── output/
    ├── png/                          # High-resolution PNG figures (300 dpi)
    ├── pdf/                          # Vector PDF figures
    └── svg/                          # Scalable vector graphics
```

---

## Experimental Design

### Biological Samples
- **Cultivars**: 15, 22, 29, 30, 32
- **Treatments**: Control (C), Treatment (T)
- **Timepoints**: 
  - Timepoint 1 (baseline)
  - Timepoint 2 (~3 months)

### Sample Naming Convention
```
C15_1  = Control, Cultivar 15, Replicate 1
T30_2  = Treatment, Cultivar 30, Replicate 2
```

Sample order is preserved as: C-Cultivar-Rep, then T-Cultivar-Rep (for each cultivar)

---

## Data Preparation Workflow

### 1. **Data Loading**
- Reads both timepoint Excel files using `readxl::read_excel()`
- Preserves all raw experimental measurements
- Combines timepoint data into a single analytical dataframe

### 2. **Standardization**
- Cleans column names using `janitor::clean_names()` for consistency
- Converts to lowercase with underscores for programmatic access
- Removes special characters and whitespace

### 3. **Metadata Extraction**
The script automatically extracts biological metadata from sample identifiers:
- **Cultivar**: Extracted numeric code (15, 22, 29, 30, 32)
- **Treatment**: Control or Treatment (derived from C/T prefix)
- **Replicate**: Replicate number (usually 1-3)
- **Timepoint**: Source timepoint (1 or 2)

### 4. **Data Validation**
- Checks for missing values per column
- Verifies metadata consistency
- Reports sample counts by cultivar and treatment

### 5. **Format Conversion**
Data transformed to long format for flexible visualization:
```R
# From wide:
sample_id | param1 | param2 | param3
C15_1     | 25.3   | 4.2    | 12.1

# To long:
sample_id | parameter | value
C15_1     | param1    | 25.3
C15_1     | param2    | 4.2
```

---

## Visualization Design

### Barplot Features

Each exploratory barplot includes:

| Element | Purpose |
|---------|---------|
| **Bars** | Mean/primary measurement per sample |
| **Color fill** | Treatment discrimination (blue=Control, orange=Treatment) |
| **Overlay points** | Raw individual replicate values |
| **X-axis** | Biological sample identity (preserved) |
| **Y-axis** | Parameter values with scientific notation |
| **Title** | Parameter name + Timepoint |
| **Legend** | Treatment identification |
| **Grid** | Y-axis gridlines for readability |
| **Theme** | Publication-ready (ggpubr base) |

### Color Scheme

- **Control**: `#0072B2` (Professional Blue) - colorblind-friendly
- **Treatment**: `#D55E00` (Professional Orange) - colorblind-friendly
- Background: Light gray (`#F5F5F5`)
- Grid lines: White

### Typography

- Font family: Sans-serif (system default)
- Axis titles: **Bold**, 11pt
- Axis labels: Regular, 10pt, 45° rotation for clarity
- Plot title: **Bold**, 12pt, centered
- Legend: 10pt

---

## Output Specifications

### File Naming Convention

```
{parameter}_barplot_tp{timepoint}.{extension}

Examples:
- height_barplot_tp1.png
- stem_diameter_barplot_tp2.pdf
- leaf_area_barplot.svg  (combined timepoints)
```

### Export Formats

| Format | Use Case | Resolution | Editability |
|--------|----------|-----------|------------|
| **PNG** | Documents, web | 300 dpi | Raster (non-editable) |
| **PDF** | Printing, archival | 300 dpi | Vector-compatible |
| **SVG** | Final editing, web | 300 dpi | Fully vector (editable) |

### Figure Dimensions

- **Width**: 12 inches
- **Height**: 7 inches
- **Resolution**: 300 dpi (print quality)
- **Format**: Landscape (optimal for comparative plots)

---

## Running the Analysis

### Prerequisites

Ensure you have R (4.0+) installed with these packages:
```R
install.packages(c(
  "tidyverse", "ggplot2", "readxl", 
  "janitor", "ggpubr", "patchwork", "viridis"
))
```

### Execution

```R
# Method 1: Run from RStudio
source("spirulina_barplot_analysis.R")

# Method 2: Command line
Rscript spirulina_barplot_analysis.R
```

### Expected Output

The script will:
1. Load and validate data
2. Create exploratory barplots for **each parameter**
3. Generate **3 versions per parameter**:
   - Timepoint 1 (specific)
   - Timepoint 2 (specific)
   - Combined (all timepoints together)
4. Export in PNG, PDF, and SVG formats
5. Display summary statistics

---

## Code Architecture

### Key Functions

#### `standardize_data(data, timepoint)`
- **Purpose**: Clean column names and add timepoint metadata
- **Input**: Raw dataframe + timepoint identifier
- **Output**: Standardized dataframe

#### `extract_metadata(data)`
- **Purpose**: Parse sample ID into biological components
- **Input**: Dataframe with sample ID column
- **Output**: Dataframe with cultivar, treatment, replicate, sample_id columns
- **Logic**: Regular expression parsing of sample naming convention

#### `create_barplot(data, parameter_name, timepoint_filter)`
- **Purpose**: Generate standardized exploratory barplot
- **Input**: Long-format data, parameter name, optional timepoint filter
- **Output**: ggplot2 plot object
- **Features**:
  - Automatic color assignment by treatment
  - Overlay raw points
  - Professional theme
  - Rotated x-axis labels

#### `export_figure(plot_obj, filename, timepoint, formats)`
- **Purpose**: Multi-format figure export with consistent naming
- **Input**: Plot object, base filename, optional timepoint, formats list
- **Output**: Files saved to output/{png|pdf|svg}/
- **Formats**: PNG, PDF, SVG (all at 300 dpi)

### Workflow Pipeline

```
Raw Excel Data
    ↓
Load & Clean Names (janitor)
    ↓
Extract Metadata (regex parsing)
    ↓
Combine Timepoints (bind_rows)
    ↓
Convert to Long Format (pivot_longer)
    ↓
For Each Parameter:
    ├─ Create TP1 Barplot → Export (PNG, PDF, SVG)
    ├─ Create TP2 Barplot → Export (PNG, PDF, SVG)
    └─ Create Combined Barplot → Export (PNG, PDF, SVG)
    ↓
Summary Report
```

---

## Data Integrity Checks

The script performs automatic validation:

✓ **Missing values detection** - Reports missing data per column  
✓ **Metadata extraction** - Verifies cultivar, treatment, replicate parsing  
✓ **Sample consistency** - Checks sample IDs across timepoints  
✓ **Numeric column identification** - Automatically detects parameters  
✓ **Dimension verification** - Confirms sample counts and structure  

---

## Reproducibility

The analysis is fully **reproducible** and **version-controlled**:

- **Modular functions** - Easy to modify specific steps
- **Heavily commented** - All logic documented
- **Hard-coded paths** - Self-contained within project directory
- **Seed-independent** - No random number generation
- **Session-independent** - Works across R versions (4.0+)

### Modifying Plots

To customize individual aspects:

```R
# Example: Change color scheme in create_barplot() function
treatment_colors <- c(
  "Control" = "#0072B2",      # Your preferred color
  "Treatment" = "#D55E00"     # Your preferred color
)

# Example: Change dimensions in export_figure()
ggsave(..., width = 14, height = 8, ...)  # Wider format

# Example: Add error bars (if replicates available)
geom_errorbar(aes(ymin = value - se, ymax = value + se), width = 0.2)
```

---

## Troubleshooting

### Issue: Package installation failures
**Solution**: Update R and install binary versions
```R
install.packages("ggplot2", type = "binary")
```

### Issue: File path errors on Windows
**Solution**: Script uses forward slashes (/) which work on all platforms. If issues persist:
```R
base_dir <- file.path("c:", "Users", "eltanany 01007675193", ...)
```

### Issue: Excel file not found
**Solution**: Verify file names match exactly (including spaces):
- `Data of timepoint 1.xlsx` ✓
- `Data of timepoint1.xlsx` ✗

### Issue: Plots not exporting
**Solution**: Check output directory permissions:
```R
dir.exists(png_dir)  # Should return TRUE
file.access(png_dir, mode = 2)  # Should return 0 (writable)
```

---

## Key Design Decisions

### 1. **No Statistical Testing**
- Purpose is exploratory visualization
- Raw data shown without p-values or significance markers
- Emphasis on biological pattern recognition

### 2. **Preserve Sample Identity**
- Each bar represents one biological sample (no averaging)
- Maintains biological replication and variability
- Supports raw data inspection for quality control

### 3. **Overlay Points on Bars**
- Shows individual measurement values
- Reveals data distribution and outliers
- Supports informal assessment of replicate consistency

### 4. **Separate Figures per Parameter**
- One parameter per plot (focused interpretation)
- Easier comparison within parameters across samples
- Optimal for multi-panel figures in manuscripts

### 5. **Multiple Export Formats**
- **PNG**: For presentations, web, rapid sharing
- **PDF**: For printing, archival, high-quality output
- **SVG**: For final editing in Adobe/Inkscape

---

## Next Steps for Manuscript Preparation

1. **Review Exploratory Plots**
   - Identify interesting patterns
   - Note biological replicates showing unusual values
   - Mark parameters for detailed analysis

2. **Statistical Analysis** (separate script)
   - ANOVA or mixed models for significance testing
   - Post-hoc comparisons if needed
   - Effect size calculations

3. **Figure Finalization**
   - Combine top plots into multi-panel figures
   - Add panel labels (A, B, C, etc.)
   - Add statistical annotations if applicable

4. **Figure Organization**
   ```
   Figure 1: Primary growth parameters (height, stem diameter)
   Figure 2: Biomass parameters (fresh weight, dry weight)
   Figure 3: Leaf morphology (leaf area, leaf number)
   Figure 4: Comparative timepoint analysis
   ```

---

## Citation and Attribution

**Analysis Date**: 2026  
**Team**: Biological Data Analyst, Scientific Visualization Specialist, Plant Data Scientist, R Programming Expert  
**Software**: R 4.0+, ggplot2, tidyverse  
**License**: Reproducible research (modify as needed for your publication)

---

## Contact & Support

For questions about:
- **Visualization logic**: See `create_barplot()` function documentation
- **Data preparation**: See section 4 (standardize_data) and section 5 (extract_metadata)
- **Export settings**: See section 9 (export_figure) and "Output Specifications"
- **Parameter identification**: Check numeric_cols list in console output

---

**Status**: ✅ Ready for publication-quality figure generation

---
*Last updated: 2026-05-25*

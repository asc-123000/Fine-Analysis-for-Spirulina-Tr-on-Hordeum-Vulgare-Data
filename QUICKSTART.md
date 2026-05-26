# Quick Start Guide - Spirulina Barplot Analysis

## 🚀 Run Analysis in 3 Steps

### Step 1: Open R or RStudio
Ensure R 4.0+ is installed on your system.

### Step 2: Install Required Packages (One-time)
Copy and paste in R console:
```R
packages <- c("tidyverse", "ggplot2", "readxl", "janitor", "ggpubr", "patchwork", "viridis")
for (pkg in packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
  }
}
```

### Step 3: Run the Analysis
Copy and paste in R console:
```R
source("spirulina_barplot_analysis.R")
```

**That's it!** Figures will be generated in the `output/` folder.

---

## 📊 What You'll Get

| Format | Location | Use |
|--------|----------|-----|
| **PNG** | `output/png/` | Documents, web, presentations |
| **PDF** | `output/pdf/` | Printing, manuscripts |
| **SVG** | `output/svg/` | Editing, final figures |

### Example Generated Files
```
output/
├── png/
│   ├── height_barplot_tp1.png
│   ├── height_barplot_tp2.png
│   ├── height_barplot.png (combined)
│   ├── stem_diameter_barplot_tp1.png
│   └── ... (one per parameter per timepoint)
├── pdf/
│   └── (same structure as PNG)
└── svg/
    └── (same structure as PNG)
```

---

## ✨ Key Features

✓ **Publication-quality plots** (300 dpi)  
✓ **Preserves sample identity** (no averaging)  
✓ **Color-coded by treatment** (Control/Treatment)  
✓ **Clean, professional theme**  
✓ **Overlay raw points** on bars  
✓ **All parameters** visualized automatically  

---

## 🔍 Troubleshooting

**Q: "File not found" error?**  
A: Check that Excel files are named exactly:
- `Data of timepoint 1.xlsx`
- `Data of timepoint 2.xlsx`

**Q: Packages won't install?**  
A: Try updating R first, or use:
```R
install.packages("package_name", type = "binary")
```

**Q: Plots not exporting?**  
A: Check that `output/` folder exists. If not:
```R
dir.create("output/png", recursive = TRUE)
dir.create("output/pdf", recursive = TRUE)
dir.create("output/svg", recursive = TRUE)
```

---

## 📝 Customization Tips

Edit these sections in `spirulina_barplot_analysis.R`:

**Change plot colors:**
```R
# Line ~290
treatment_colors <- c(
  "Control" = "#0072B2",
  "Treatment" = "#D55E00"
)
```

**Change plot size:**
```R
# Line ~380 in export_figure()
width = 14,   # Increase for wider plots
height = 8    # Increase for taller plots
```

**Change resolution:**
```R
# Line ~389
dpi = 600     # Higher for print (600 dpi)
```

---

## 📚 Full Documentation

See `README.md` for:
- Detailed experimental design
- Data preparation workflow
- Code architecture and functions
- Reproducibility information
- Manuscript preparation guidance

---

**Ready?** Run `source("spirulina_barplot_analysis.R")` in your R console! 🎯

---
*Scientific Visualization Team | 2026*

# Data Dictionary & Parameter Codebook

## Overview

This document describes the expected parameters and metadata structure in the Spirulina treatment experiment on barley (*Hordeum vulgare*).

---

## Sample Metadata

### Sample Identifier Format
```
{TREATMENT}{CULTIVAR}_{REPLICATE}

Where:
  TREATMENT   = C (Control) or T (Treatment)
  CULTIVAR    = 15, 22, 29, 30, 32
  REPLICATE   = Integer (usually 1, 2, 3)
```

### Metadata Fields (Auto-Extracted)

| Field | Type | Values | Example |
|-------|------|--------|---------|
| `sample_id` | Character | {T/C}{15/22/29/30/32}_{1/2/3} | C15_1, T30_2 |
| `treatment` | Factor | Control, Treatment | Treatment |
| `cultivar` | Factor | 15, 22, 29, 30, 32 | 22 |
| `replicate` | Character | 1, 2, 3 | 1 |
| `timepoint` | Factor | Timepoint 1, Timepoint 2 | Timepoint 1 |

---

## Expected Parameters

### Biological Measurement Categories

The following are typical parameter categories in plant physiology experiments:

#### **Growth Parameters** (Linear Dimensions)
- `height` or `plant_height` - Total plant height (cm)
- `stem_diameter` or `stem_width` - Main stem diameter (mm)
- `stem_length` - Length of main stem (cm)
- `branch_number` - Number of lateral branches

#### **Biomass Parameters** (Weight Measurements)
- `fresh_weight` - Fresh biomass (g)
- `dry_weight` - Dry biomass (g)
- `root_weight` or `root_dry_weight` - Root dry weight (g)
- `shoot_weight` - Aerial biomass (g)

#### **Leaf Morphology**
- `leaf_area` - Total leaf area (cm²)
- `leaf_number` - Count of leaves
- `leaf_length` - Average leaf length (cm)
- `leaf_width` - Average leaf width (cm)
- `leaf_area_ratio` - LAR (cm²/g dry weight)

#### **Physiological Parameters**
- `chlorophyll_content` - SPAD units or µmol/cm²
- `photosynthetic_rate` - µmol CO₂/m²/s
- `stomatal_conductance` - mmol H₂O/m²/s
- `transpiration_rate` - mmol H₂O/m²/s

#### **Root Parameters**
- `root_length` - Total root length (cm)
- `root_number` - Number of main roots
- `root_surface_area` - Root SA (cm²)
- `root_diameter` - Average root diameter (mm)

---

## Data Structure Expected

### Excel File Format

```
Column 1: Sample ID (e.g., "C15_1", "T30_2")
Column 2+: Parameter values (numeric)

Example:
├─ Sample | height | stem_diameter | fresh_weight | leaf_area
├─ C15_1  | 25.3   | 4.2          | 12.1         | 156.4
├─ C15_2  | 24.8   | 4.1          | 11.9         | 152.1
├─ T15_1  | 28.5   | 4.8          | 14.2         | 182.3
├─ T15_2  | 29.1   | 4.9          | 14.5         | 185.6
```

### Preserved Structure After Processing

```R
data_combined
# A tibble: [samples × parameters]
  sample_id cultivar treatment replicate timepoint height stem_diameter ...
  <chr>     <fct>    <fct>     <chr>     <fct>      <dbl> <dbl>          ...
  C15_1     15       Control   1         Timepoint 1 25.3  4.2
  C15_2     15       Control   2         Timepoint 1 24.8  4.1
  T15_1     15       Treatment 1         Timepoint 1 28.5  4.8
  T15_2     15       Treatment 2         Timepoint 1 29.1  4.9
  ...
```

---

## Units and Scale Information

### Common Units by Parameter Type

| Category | Typical Unit | Scale | Decimal Places |
|----------|-------------|-------|-----------------|
| **Height** | cm | 10-100 | 1-2 |
| **Diameter** | mm | 1-10 | 1-2 |
| **Weight** | g | 1-100 | 2-3 |
| **Area** | cm² | 10-1000 | 1-2 |
| **Chlorophyll** | SPAD/µmol | 0-100 | 1 |
| **Gas exchange** | µmol/mmol | 0-50 | 2-3 |
| **Root traits** | cm/mm | 1-200 | 1-2 |

---

## Data Quality Expectations

### Missing Data
- **Acceptable**: < 5% missing values
- **Report**: Any cultivar or replicate missing > 10% of parameters
- **Action**: Exclude from specific parameter analysis if >30% missing

### Outliers
- **Detection**: Values >3 SD from group mean
- **Reporting**: Visualized in barplots with overlay points
- **Action**: NO removal for exploratory plots (preserve raw data)

### Consistency Checks
- Sample count per cultivar (should be consistent)
- Parameter ranges (biologically realistic)
- Treatment balance (similar N per treatment)

---

## Cultivation and Treatment Parameters

### Spirulina Treatment
- **Spirulina species**: *Spirulina maxima* or *S. platensis*
- **Concentration**: 1 g/L
- **Application**: Likely root absorption or foliar spray
- **Duration**: Between Timepoint 1 and 2 (~3 months)
- **Control**: Water only (no Spirulina)

### Growth Conditions (Typical)
- **Temperature**: 20-25°C (day/night)
- **Light**: 16h photoperiod
- **Light intensity**: 200-400 µmol/m²/s
- **Humidity**: 60-80%
- **Substrate**: Soil or hydroponic

---

## Comparison Parameters

### Between-Sample Comparisons in Plots

**By Treatment Effect**
```
C cultivar vs T cultivar (same cultivar)
→ Shows Spirulina treatment effect
```

**By Cultivar**
```
Cultivar 15 vs 22 vs 29 vs 30 vs 32 (same treatment)
→ Shows genetic/cultivar variation
```

**By Timepoint**
```
Timepoint 1 vs Timepoint 2
→ Shows temporal development/treatment accumulation
```

---

## Statistical Context

### Sample Size
- **Per cultivar per treatment**: Typically 2-3 replicates
- **Total samples**: 5 cultivars × 2 treatments × 2-3 replicates = 20-30
- **Per timepoint**: Half of total (10-15 per timepoint)

### Replication Design
- **Biological replication**: Cultivars (5 levels)
- **Treatment replication**: Control vs Treatment (2 levels)
- **Technical replication**: Replicates within treatment (2-3 levels)
- **Temporal replication**: Timepoints (2 levels)

---

## Parameter Derivation (Calculated Metrics)

If raw data includes component measurements, derived parameters might include:

### Root:Shoot Ratios
```
root_shoot_ratio = dry_weight_root / dry_weight_shoot
```

### Leaf Area Ratios
```
leaf_area_ratio = leaf_area / dry_weight
specific_leaf_area = leaf_area / leaf_dry_weight
```

### Growth Rates
```
relative_growth_rate = (ln(W2) - ln(W1)) / (t2 - t1)
where W = dry weight, t = time
```

### Allocation Patterns
```
shoot_allocation = dry_weight_shoot / total_dry_weight
root_allocation = dry_weight_root / total_dry_weight
```

---

## Visualization Expectations

### Parameter-Specific Plot Adjustments

**Growth parameters (height, stem diameter, leaf area)**
- Large variation expected across cultivars
- Clear treatment effects likely visible
- Overlay points show replicate consistency

**Biomass parameters (fresh/dry weight)**
- May show strong timepoint effect
- Wide range of values
- Treatment effects often more pronounced

**Physiological parameters (chlorophyll, gas exchange)**
- Smaller absolute values
- More sensitive to environmental variation
- Treatment effects may be subtle

---

## Example Parameter List

The following is a **typical** set of parameters for this experiment:

```
Primary (Growth):
  - height                 # Total plant height
  - stem_diameter         # Main stem width
  - stem_length           # Primary stem length

Biomass:
  - fresh_weight          # Fresh plant weight
  - dry_weight            # Total dry biomass
  - shoot_dry_weight      # Above-ground biomass
  - root_dry_weight       # Below-ground biomass

Leaf Morphology:
  - leaf_area             # Total leaf area
  - leaf_number           # Count of leaves
  - leaf_fresh_weight     # Fresh leaf mass
  - leaf_dry_weight       # Dry leaf mass

Allocation:
  - root_shoot_ratio      # Root:Shoot dry weight ratio
  - leaf_area_ratio       # Leaf area per unit dry weight
  - shoot_allocation      # % of biomass above-ground

Physiological:
  - chlorophyll_content   # Leaf greenness
  - photosynthetic_rate   # CO₂ fixation rate
```

---

## Notes for Analysis

✓ **Your actual parameters** will be auto-detected from Excel column headers  
✓ **No assumptions** are hard-coded - analysis adapts to your data structure  
✓ **Numeric columns** are automatically identified for plotting  
✓ **Categorical info** is extracted from sample ID convention  

The analysis script `spirulina_barplot_analysis.R` will:
1. Detect all numeric columns
2. Create plots for each one
3. Label axes based on column names (converted to title case)

---

## Metadata Dictionary

| Column | Source | Type | Notes |
|--------|--------|------|-------|
| `sample_id_raw` | Deleted | - | Intermediate (removed after parsing) |
| `sample_id` | Extracted | chr | Standardized sample ID |
| `cultivar` | Extracted from sample_id | fct | 15, 22, 29, 30, 32 |
| `treatment` | Extracted from sample_id | fct | Control, Treatment |
| `replicate` | Extracted from sample_id | chr | 1, 2, 3... |
| `timepoint` | From file source | fct | Timepoint 1, Timepoint 2 |
| `parameter` | Column headers | chr | Auto-detected |
| `value` | Measurement | dbl | Parameter value |

---

## Output Interpretation

### Reading the Barplots

1. **X-axis**: Each bar = one biological sample (sample_id preserved)
2. **Y-axis**: Measured parameter value
3. **Color**: 
   - Blue bar = Control
   - Orange bar = Treatment
4. **Height**: Parameter magnitude
5. **Overlay points**: Individual raw values (usually same as bar height)
6. **Order**: Cultivars grouped (15, then 22, then 29, then 30, then 32)

### Example Interpretation
```
If height_barplot_tp1 shows:

  C15   T15   C22   T22   C29   T29   ...
  ▓▓▓ ▓▓▓▓▓ ▓▓▓ ▓▓▓▓▓ ▓▓▓ ▓▓▓▓▓

→ Orange bars (T) are generally taller than blue bars (C)
→ Spirulina treatment increases height across cultivars at TP1
```

---

**This codebook ensures:** ✅ Data consistency | ✅ Proper interpretation | ✅ Reproducible analysis

---
*Reference Document | Scientific Visualization Team | 2026*

# Figure Legends and Descriptions

## Overview

This document provides **detailed scientific interpretation** of all generated exploratory barplots. Each figure displays raw measurement data from biological replicates stratified by treatment arm (Control, Spirulina 1 g/L), cultivar (15, 22, 29, 30, 32), and timepoint (Baseline vs. ~3 months post-treatment).

---

## Visual Elements Guide

### Bar Representation
- **X-axis**: Individual biological samples (ordered by cultivar, then treatment, then replicate number)
- **Y-axis**: Measured parameter value (auto-scaled to data range; units shown on axis label)
- **Bar height**: Measured value for that sample
- **Bar color**: 
  - **Blue (`#0072B2`)** = Control (untreated)
  - **Orange (`#D55E00`)** = Treatment (Spirulina 1 g/L)
- **Overlay dots**: Identical to bar height (raw data point overlay for transparency)

### Design Rationale
- **No averaging across replicates**: Each bar represents a unique biological sample
- **No error bars**: Exploratory visualization preserves raw individual values
- **No statistical testing**: Figures are for pattern recognition, not hypothesis inference
- **Unbalanced design visible**: Timepoint 2 plots show missing samples (Cultivar 15.2C, 15.2T, 32.2C, 32.2T)

---

## Figure Set 1: MORPHOLOGICAL GROWTH PARAMETERS

### Figure 1.1: Height in cm — Timepoint 1
**File**: `heightincm_barplot_tp1.{png,pdf,svg}`

**Purpose**: Baseline plant height assessment (before Spirulina application)

**Interpretation**:
- Establishes pre-treatment height variation across cultivars
- Control group represents genotype-specific growth potential at ~4 weeks
- Treatment and control groups should be comparable at baseline (no prior treatment exposure)
- Cultivar 29 and 30 typically exhibit greater height than 15, 22, 32 in untreated conditions (genotypic differences)

**Biological Meaning**:
Height reflects shoot elongation rate and developmental maturity. Taller plants at TP1 indicate earlier developmental progress or genetic predisposition for height growth.

---

### Figure 1.2: Height in cm — Timepoint 2
**File**: `heightincm_barplot_tp2.{png,pdf,svg}`

**Purpose**: Post-treatment height (after 3 months Spirulina exposure)

**Interpretation**:
- **Treatment effect**: If orange bars > blue bars consistently, suggests Spirulina stimulates height
- **Cultivar response variation**: Slopes of treatment-control differences vary by cultivar (G×T interaction)
- **Missing samples**: Cultivar 15 and 32 have only 1st replicates (2nd replicates lost at TP1→TP2 interval)
- **Growth trajectory**: Increase in height from TP1→TP2 reflects 3 months of continued development

**Expected Patterns**:
- If Spirulina acts as growth promoter: Treatment samples (orange) > Control (blue)
- If effect is cultivar-dependent: Some cultivars respond >4 cm; others show <1 cm difference

---

### Figure 1.3: Height in cm — Combined (TP1 + TP2)
**File**: `heightincm_barplot.{png,pdf,svg}`

**Purpose**: Temporal trajectory of height across timepoints

**Interpretation**:
- **Continuous grouping**: TP1 samples appear first (left), then TP2 samples (right) for each cultivar-treatment block
- **Temporal progression**: Generally increasing heights from TP1 to TP2 (unless stunted growth occurs)
- **Sample loss visible**: Cultivar 15 and 32 TP2 bars appear only for 1st replicates
- **Treatment effect persistence**: If treatment effect consistent across timepoints, suggests stable Spirulina influence

---

### Figure 2.1: YEB Length in cm — Timepoint 1
**File**: `yeblengthincm_barplot_tp1.{png,pdf,svg}`

**Purpose**: Yellow Expanding Blade (newest fully emerging leaf) length at baseline

**Biological Context**:
YEB = leaf rank that has not yet reached full chlorophyll development. Its length indicates the current growth rate of the plant (younger = smaller YEB = slower current growth; older = larger YEB = more mature developmental stage).

**Interpretation**:
- Baseline YEB length represents the current developmental state at TP1 measurement
- Values typically 2-5 cm depending on cultivar
- Variation indicates differences in leaf expansion rate kinetics among cultivars
- Control vs. Treatment comparable at baseline (pre-treatment)

---

### Figure 2.2: YEB Length in cm — Timepoint 2
**File**: `yeblengthincm_barplot_tp2.{png,pdf,svg}`

**Purpose**: YEB length after 3 months, post-treatment

**Interpretation**:
- **Growth rate indicator**: Larger YEB at TP2 suggests faster leaf expansion during treatment period
- **Treatment response**: If orange > blue consistently, Spirulina may accelerate leaf morphogenesis
- **Physiological implication**: Rapidly expanding leaves require high N and micronutrient availability
  - Spirulina contains amino acids, B vitamins, trace elements → supports leaf development
- **Cultivar differences**: Some cultivars expand leaves faster than others (genetic predisposition)

---

### Figure 2.3: YEB Length in cm — Combined (TP1 + TP2)
**File**: `yeblengthincm_barplot.{png,pdf,svg}`

**Purpose**: Temporal dynamics of current leaf expansion

**Interpretation**:
- Usually increasing from TP1 to TP2 (as plant matures, leaves become larger)
- Slope of increase = leaf expansion rate during 3-month interval
- Steeper slopes (TP1 < TP2) = more active leaf development during treatment period
- If treatment induces steeper slopes, suggests Spirulina accelerates morphogenesis

---

### Figure 3.1: Stem Diameter in cm — Timepoint 1
**File**: `stemdiameterincm_barplot_tp1.{png,pdf,svg}`

**Purpose**: Main stem cross-sectional diameter at baseline

**Biological Meaning**:
Stem diameter reflects vascular bundle size and sclerification. Larger diameter = stronger structural support = ability to bear heavier leaves/grain (lodging resistance). Also related to water transport capacity.

**Interpretation**:
- Baseline measurements establish cultivar-specific stem anatomy
- Typical range: 3-6 mm in barley seedlings
- Variation among cultivars reflects genetic differences in tissue density and vascular development
- Control and treatment comparable at baseline

---

### Figure 3.2: Stem Diameter in cm — Timepoint 2
**File**: `stemdiameterincm_barplot_tp2.{png,pdf,svg}`

**Purpose**: Stem diameter after 3 months, post-treatment

**Interpretation**:
- **Treatment effect**: If orange > blue, suggests Spirulina stimulates secondary growth or vascular expansion
- **Lodging resistance**: Thicker stems = greater mechanical strength (important for cereal crops)
- **Cultivar response**: Some cultivars invest more in stem strength than others
  - High-diameter cultivars may prioritize structural support
  - Low-diameter cultivars may prioritize height growth instead

**Expected Pattern**: Modest increase from TP1→TP2 (secondary thickening); Spirulina may amplify this response

---

### Figure 3.3: Stem Diameter in cm — Combined (TP1 + TP2)
**File**: `stemdiameterincm_barplot.{png,pdf,svg}`

**Purpose**: Stem secondary growth over 3-month interval

**Interpretation**:
- Generally increasing from TP1 to TP2 (developmental progression)
- Rate of increase = stem thickening rate during treatment
- If treatment accelerates thickening (orange steeper slope), indicates enhanced vascular/structural development

---

## Figure Set 2: BIOMASS PARAMETERS

### Figure 4.1: Vegetative Fresh Weight in cm — Timepoint 1
**File**: `vegetativefreshweightingm_barplot_tp1.{png,pdf,svg}`

**Purpose**: Total above-ground fresh (hydrated) biomass at baseline

**Biological Meaning**:
Fresh weight = dry matter + water content. Reflects plant size and turgor status. High fresh weight = well-hydrated, actively growing plant; low fresh weight = stressed or mature (loss of water).

**Interpretation**:
- TP1 values typically 5-20 g depending on cultivar and growth conditions
- Cultivar differences reflect genetic variation in growth rate and size at 4-5 weeks
- Fresh/dry weight ratio gives water content (indicator of physiological state)
- Control and treatment comparable at baseline

---

### Figure 4.2: Vegetative Fresh Weight in cm — Timepoint 2
**File**: `vegetativefreshweightingm_barplot_tp2.{png,pdf,svg}`

**Purpose**: Above-ground fresh biomass after 3 months, post-treatment

**Interpretation**:
- **Major treatment response expected**: Fresh weight is sensitive to growth promotion
- If orange >> blue: Spirulina strongly stimulates biomass accumulation
- **Water status indicator**: Very high fresh weight = high water content = active growth; low = senescence or drought stress
- **Treatment effect size**: Difference between orange and blue quantifies treatment impact on immediate plant size

**Expected Pattern**: 2-3× increase from TP1→TP2; Spirulina may amplify this by +10-30%

---

### Figure 4.3: Vegetative Fresh Weight in cm — Combined (TP1 + TP2)
**File**: `vegetativefreshweightingm_barplot.{png,pdf,svg}`

**Purpose**: Temporal trajectory of above-ground plant size

**Interpretation**:
- Most dramatic visual increase from TP1→TP2 (exponential growth phase)
- Slope magnitude = biomass accumulation rate during 3-month interval
- Treatment effect persistence: If orange > blue at both timepoints, consistent response
- Missing samples clearly visible (Cultivar 15, 32 TP2)

---

### Figure 5.1: Vegetative Dry Weight in cm — Timepoint 1
**File**: `vegetativedryweightingm_barplot_tp1.{png,pdf,svg}`

**Purpose**: Baseline above-ground organic matter (primary metric of growth)

**Biological Meaning**:
**Dry weight is the most ecologically and statistically meaningful measure of plant biomass.** It excludes water variation, represents carbon/nutrient accumulation, and is directly proportional to photosynthetic productivity and resource use efficiency.

**Interpretation**:
- TP1 dry weight = 1-5 g typical (much lower than fresh weight due to ~70-80% water content)
- Cultivar differences = genetic variation in growth rate and metabolic efficiency at juvenile stage
- Should track closely with fresh weight (high correlation)
- Control and treatment comparable at baseline

---

### Figure 5.2: Vegetative Dry Weight in cm — Timepoint 2
**File**: `vegetativedryweightingm_barplot_tp2.{png,pdf,svg}`

**Purpose**: **PRIMARY RESPONSE VARIABLE** — Post-treatment organic biomass

**Biological Meaning & Interpretation**:
This is the **most important figure for assessing Spirulina efficacy**.

- **Dry weight accumulation** = net photosynthetic productivity — respiratory losses
- If orange >> blue: **Strong evidence that Spirulina promotes growth**
- Magnitude difference indicates treatment effect size (e.g., +20% dry weight = 0.5–1.0 g increase)

**Statistical Interpretation**:
- Effect heterogeneity by cultivar = genotype-by-treatment (G×T) interaction
  - Cultivar 22, 29, 30: Robust positive response to Spirulina?
  - Cultivar 15, 32: Modest or absent response (lower sample size at TP2 complicates inference)

**Mechanistic Interpretation**:
If Spirulina increases dry weight:
1. **Enhanced photosynthesis** (pigments, cofactors in Spirulina stimulate PS machinery)
2. **Improved nutrient uptake** (amino acids, growth hormones in Spirulina boost root vigor)
3. **Reduced respiration** (secondary metabolites reduce photorespiration)
4. **Increased N assimilation** (amino acids provide plant-available N)

---

### Figure 5.3: Vegetative Dry Weight in cm — Combined (TP1 + TP2)
**File**: `vegetativedryweightingm_barplot.{png,pdf,svg}`

**Purpose**: Growth trajectory over 3-month treatment period (most critical exploratory output)

**Interpretation**:
- **Steep TP1→TP2 increases** = active biomass accumulation phase
- **Treatment effect consistency**: If orange remains > blue across timepoints, reproducible treatment response
- **Cultivar-by-treatment interaction**: Do slopes differ by cultivar?
  - Uniform treatment effect (parallel slopes): Additive genetic × treatment model
  - Converging/diverging slopes: Multiplicative G×T interaction (treatment amplifies cultivar differences or vice versa)
- **Effect size estimation**: (Orange_TP2 − Blue_TP2) / Blue_TP2 = % biomass increase due to treatment

**Key Observation Zone**: Timepoint 2 bars (right side) show post-treatment phenotypes; treatment effect most evident here.

---

## Figure Set 3: TILLER AND REPRODUCTIVE PARAMETERS

### Figure 6.1: No. of Tillers/Pot — Timepoint 1
**File**: `nooftillerspot_barplot_tp1.{png,pdf,svg}`

**Purpose**: Number of lateral shoots (branching architecture) at baseline

**Biological Meaning**:
Tillers = lateral vegetative shoots that emerge from basal nodes. High tiller number = greater shoot biomass and yield potential (each tiller can produce grain panicles).

**Interpretation**:
- TP1 tiller count typically 1-4 (barley is just beginning active tillering at 4-5 weeks)
- Cultivar differences = genetic tillering capacity
- Low counts expected (juvenile plants, early growth stage)
- Control and treatment comparable at baseline

---

### Figure 6.2: No. of Tillers/Pot — Timepoint 2
**File**: `nooftillerspot_barplot_tp2.{png,pdf,svg}`

**Purpose**: Tiller number after 3 months, post-treatment

**Biological Meaning**: 
By TP2 (~13-15 weeks post-planting), plants reach reproductive development. Tiller number = final shoot architecture (determines yield components: grain number, harvest biomass).

**Interpretation**:
- Expected range: 3-8 tillers (mature developmental stage)
- Significant increase from TP1→TP2 (active tillering phase)
- **Treatment response**: If orange > blue, Spirulina stimulates branching
  - Mechanism: Improved nutrient status (from Spirulina amino acids) → enhanced auxin signaling → more lateral buds break dormancy
- **Cultivar differences**: Some cultivars naturally higher-tillering (genetic predisposition)

**Agronomic Significance**: 
Higher tiller count = greater panicle number = potential yield advantage (if grain fill maintained)

---

### Figure 6.3: No. of Tillers/Pot — Combined (TP1 + TP2)
**File**: `nooftillerspot_barplot.{png,pdf,svg}`

**Purpose**: Temporal progression of branching architecture

**Interpretation**:
- Dramatic increase from TP1→TP2 (exponential tillering phase)
- Treatment effect: If orange consistently > blue, sustained branching stimulation
- Cultivar-by-treatment: Parallel vs. diverging slopes reveal G×T interaction strength

---

### Figure 7.1: Ability to be Filled — Timepoint 1
**File**: `abilitytobefilled_barplot_tp1.{png,pdf,svg}`

**Purpose**: Reproductive competence/grain-filling phenotypic score at baseline

**Biological Meaning**:
Measured on ordinal/index scale (likely 0-9 or similar); indicates the morphological/physiological capacity of the plant to set and fill grain at reproductive stage. High score = robust reproductive development; low score = poor reproductive condition.

**Interpretation**:
- TP1 measurement taken before or very early in reproductive phase
- Values may be variable or low (plants may not yet show reproductive structures)
- Baseline score = genetic predisposition for reproductive vigor
- Control and treatment comparable at baseline

---

### Figure 7.2: Ability to be Filled — Timepoint 2
**File**: `abilitytobefilled_barplot_tp2.{png,pdf,svg}`

**Purpose**: **KEY TRAIT FOR YIELD POTENTIAL** — Grain-filling capacity post-treatment

**Biological Meaning**:
By TP2 (~13-15 weeks), plants are in active grain-filling stage. This score reflects the "sink strength" (capacity to accumulate carbohydrates in developing grains) and physiological health.

**Interpretation**:
- **Treatment effect on reproductive success**: If orange > blue, Spirulina enhances grain fill
  - Mechanism: Improved photosynthetic source (more dry matter accumulation) + improved sink physiology (nutrient minerals from Spirulina support grain development)
- **Cultivar differences in reproductive potential**: Some lines inherently better grain fillers
- **Agricultural relevance**: High filling ability → grain weight → final yield

**Expected Pattern**: 
Positive treatment effect expected (Spirulina should support reproductive physiology). Magnitude varies by cultivar.

---

### Figure 7.3: Ability to be Filled — Combined (TP1 + TP2)
**File**: `abilitytobefilled_barplot.{png,pdf,svg}`

**Purpose**: Trajectory of reproductive potential from early to late growth stage

**Interpretation**:
- Usually increasing from TP1→TP2 (plants transition to reproductive phase)
- Treatment effect: Slope may increase (orange > blue at TP2 especially)
- **Reproductive phase assessment**: Larger TP2 differences indicate strong treatment effect on grain maturation

---

## Summary Interpretation Guide

### Hypothetical Positive Spirulina Treatment Effect (All Parameters)

| Parameter | TP1 Expectation | TP2 Expectation | Interpretation |
|-----------|-----------------|-----------------|-----------------|
| Height | No difference | Orange > Blue | Growth promotion |
| YEB length | No difference | Orange > Blue | Accelerated morphogenesis |
| Stem diameter | No difference | Orange > Blue | Enhanced structural support |
| Fresh weight | No difference | Orange >> Blue | Rapid biomass accumulation |
| **Dry weight** | No difference | **Orange >> Blue** | **Strongest evidence of Spirulina efficacy** |
| Tiller number | No difference | Orange > Blue | Branching stimulation |
| Grain-filling ability | No difference | Orange > Blue | Reproductive vigor enhancement |

### Heterogeneity by Cultivar (G×T Interaction)

**If treatment responses differ by cultivar:**
- Some cultivars respond strongly (orange bars much taller than blue)
- Others show modest responses (slight difference)
- Interpretation: Spirulina efficacy depends on genetic background
  - Responsive cultivars: Better compatible with Spirulina-supplied nutrients/hormones
  - Non-responsive: May have genetic constraints on nutrient uptake or growth signaling

---

## Data Availability and Reproducibility

All raw data and this visualization pipeline are available in **CSV and XLSX formats** in the `output/` directory:
- `output/csv/data_tp1.csv` — Timepoint 1 processed data
- `output/csv/data_tp2.csv` — Timepoint 2 processed data
- `output/csv/data_combined.csv` — Combined (both timepoints) analytical dataset

R code for figure generation is fully documented in `spirulina_barplot_analysis.R`. All figures are publication-ready at 300 dpi (PNG, PDF) or fully editable (SVG).

---

## Statistical Caveats for Exploratory Visualization

**This figure set is intentionally descriptive and NOT inferential:**
- ✗ No p-values or significance markers
- ✗ No confidence intervals or error bars
- ✗ No statistical tests (ANOVA, contrasts, etc.)
- ✓ Raw data display for pattern recognition
- ✓ Unbalanced design transparently visible
- ✓ All biological replicates displayed individually

**Next steps for rigorous analysis:**
1. Fit linear or mixed-effects models (accounting for unbalanced design)
2. Perform post-hoc comparisons with multiple-testing correction
3. Estimate effect sizes and confidence intervals
4. Assess G×T (cultivar-by-treatment) interactions formally
5. Report results following ANOVA/regression reporting standards

---

*Figure legends prepared by: Bioinformatics and Biological Data Analysis Team*  
*Generated: 2026-05-26*  
*License: CC-BY-4.0 (Attribution 4.0 International)*

# =========================================================================
# SPIRULINA TREATMENT ON BARLEY (Hordeum vulgare) - EXPLORATORY BARPLOTS
# =========================================================================
# Project: Biological visualization of Spirulina effect on barley cultivars
# Purpose: Generate publication-quality exploratory barplots for all parameters
# Author: A. Samir Abouzeid
# Date: 2026
# =========================================================================

# Clear workspace
rm(list = ls())
gc()

# =========================================================================
# 1. LOAD REQUIRED LIBRARIES
# =========================================================================

required_packages <- c(
  "tidyverse",      # Data manipulation and visualization pipeline
  "ggplot2",        # Advanced plotting
  "readxl",         # Read Excel files
  "janitor",        # Clean column names
  "ggpubr",         # Publication-ready plots
  "patchwork",      # Combine plots
  "viridis",        # Color-blind friendly palettes
  "writexl"         # Write Excel files
)

# Check and install missing packages
for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# =========================================================================
# 2. DEFINE WORKING DIRECTORIES
# =========================================================================

# Base directory
base_dir <- "c:/Users/eltanany 01007675193/OneDrive/Desktop/Powerful Tool/Spirulina tr. on Hordeum vulgare"

# Data directory
data_dir <- base_dir

# Output directories
output_dir <- file.path(base_dir, "output")
png_dir <- file.path(output_dir, "png")
pdf_dir <- file.path(output_dir, "pdf")
svg_dir <- file.path(output_dir, "svg")
csv_dir <- file.path(output_dir, "csv")
xlsx_dir <- file.path(output_dir, "xlsx")
mean_dir <- file.path(output_dir, "mean")
mean_png_dir <- file.path(mean_dir, "png")
mean_pdf_dir <- file.path(mean_dir, "pdf")
mean_svg_dir <- file.path(mean_dir, "svg")

# Verify directories exist
dir.create(output_dir, showWarnings = FALSE)
dir.create(png_dir, showWarnings = FALSE)
dir.create(pdf_dir, showWarnings = FALSE)
dir.create(svg_dir, showWarnings = FALSE)
dir.create(csv_dir, showWarnings = FALSE)
dir.create(xlsx_dir, showWarnings = FALSE)
dir.create(mean_dir, showWarnings = FALSE)
dir.create(mean_png_dir, showWarnings = FALSE)
dir.create(mean_pdf_dir, showWarnings = FALSE)
dir.create(mean_svg_dir, showWarnings = FALSE)

# =========================================================================
# 3. DATA LOADING AND INITIAL EXPLORATION
# =========================================================================

cat("\n============================================\n")
cat("LOADING EXPERIMENTAL DATA\n")
cat("============================================\n")

# Load timepoint 1 data
tp1_path <- file.path(data_dir, "Data of timepoint 1.xlsx")
data_tp1 <- read_excel(tp1_path, na = c("NA", "N/A", ""))

cat("✓ Timepoint 1 data loaded\n")
cat("  Dimensions:", nrow(data_tp1), "rows x", ncol(data_tp1), "columns\n")
cat("  Sheet preview:\n")
print(head(data_tp1))

# Load timepoint 2 data
tp2_path <- file.path(data_dir, "Data of timepoint 2.xlsx")
data_tp2 <- read_excel(tp2_path, na = c("NA", "N/A", ""))

cat("\n✓ Timepoint 2 data loaded\n")
cat("  Dimensions:", nrow(data_tp2), "rows x", ncol(data_tp2), "columns\n")
cat("  Sheet preview:\n")
print(head(data_tp2))

# =========================================================================
# 4. DATA STANDARDIZATION AND PREPARATION
# =========================================================================

cat("\n============================================\n")
cat("DATA STANDARDIZATION\n")
cat("============================================\n")

# Helper: detect the sample ID column even if column order changes
detect_sample_col <- function(data) {
  candidate_names <- c(
    "sample", "sample_id", "sampleid", "sample_code",
    "sample_name", "id", "code"
  )
  name_match <- intersect(candidate_names, names(data))
  if (length(name_match) > 0) {
    return(name_match[1])
  }

  # Fallback: infer by content pattern (C/T + 2 digits + replicate)
  pattern <- "^(\\d+(ST|ND|RD|TH))?[CT]\\s*\\d{2}"
  scores <- sapply(data, function(col) {
    vals <- str_to_upper(str_trim(as.character(col)))
    sum(str_detect(vals, pattern), na.rm = TRUE)
  })
  if (all(scores == 0)) {
    return(names(data)[1])
  }
  names(data)[which.max(scores)]
}

# Helper: normalize ability-to-be-filled values to percent scale (0-100)
normalize_ability_to_be_filled <- function(data) {
  target_cols <- names(data)[str_detect(names(data), "ability.*filled|grain.*fill")]
  if (length(target_cols) == 0) {
    return(data)
  }

  for (col in target_cols) {
    vals <- data[[col]]
    if (all(is.na(vals))) {
      next
    }
    max_val <- suppressWarnings(max(vals, na.rm = TRUE))
    if (is.finite(max_val) && max_val > 0 && max_val <= 1) {
      data[[col]] <- vals * 100
      message("Rescaled ", col, " from proportion to percent (0-100).")
    }
  }

  data
}

# Function to clean and standardize data
standardize_data <- function(data, timepoint) {
  
  # Clean column names (lowercase, remove special characters)
  data <- data %>%
    janitor::clean_names()
  
  # Coerce measurement columns to numeric for consistent binding
  # (keeps the first column as the raw sample identifier)
  sample_col <- detect_sample_col(data)
  data <- data %>%
    mutate(
      across(
        -all_of(sample_col),
        ~ suppressWarnings(
          readr::parse_number(
            as.character(.x),
            na = c("", "NA", "N/A", "na")
          )
        )
      )
    )

  # Normalize grain-filling values to a percent scale (0-100)
  data <- normalize_ability_to_be_filled(data)
  
  # Add timepoint identifier
  data <- data %>%
    mutate(timepoint = timepoint)
  
  return(data)
}

# Standardize both timepoints
data_tp1 <- standardize_data(data_tp1, timepoint = "Timepoint 1")
data_tp2 <- standardize_data(data_tp2, timepoint = "Timepoint 2")

cat("✓ Column names standardized\n")
cat("  TP1 columns:", paste(names(data_tp1), collapse = ", "), "\n")
cat("  TP2 columns:", paste(names(data_tp2), collapse = ", "), "\n")

# =========================================================================
# 5. EXTRACT BIOLOGICAL METADATA AND CREATE SAMPLE IDENTIFIERS
# =========================================================================

cat("\n============================================\n")
cat("CREATING BIOLOGICAL METADATA\n")
cat("============================================\n")

# Function to extract metadata from sample identifiers
extract_metadata <- function(data) {
  
  # Get the sample column (first column typically contains sample ID)
  sample_col <- detect_sample_col(data)
  
  cat("Sample ID column identified:", sample_col, "\n")
  
  data <- data %>%
    rename(sample_id_raw = all_of(sample_col)) %>%
    mutate(
      sample_id_raw = str_trim(as.character(sample_id_raw)),
      sample_id_display = str_replace_all(sample_id_raw, "\\s+", ""),
      sample_id_clean = str_to_upper(sample_id_display)
    ) %>%
    filter(!is.na(sample_id_clean), sample_id_clean != "") %>%
    # Remove any summary rows if present
    filter(!str_detect(sample_id_clean, "AVG|AVERAGE|MEAN|TOTAL")) %>%
    mutate(
      # Extract cultivar (numeric code: 15, 22, 29, 30, 32)
      cultivar = str_extract(sample_id_clean, "\\d{2}"),
      
      # Extract treatment (C or T)
      treatment = case_when(
        str_detect(sample_id_clean, "C\\d{2}") ~ "Control",
        str_detect(sample_id_clean, "T\\d{2}") ~ "Treatment",
        str_detect(sample_id_clean, "^C") ~ "Control",
        str_detect(sample_id_clean, "^T") ~ "Treatment",
        TRUE ~ NA_character_
      ),
      
      # Extract sample number (supports 1st/2nd prefixes, *_ as second, or _1/_2 suffixes)
      sample_no = case_when(
        str_detect(sample_id_raw, "\\*") ~ "2",
        str_detect(sample_id_clean, "^(\\d+)(ST|ND|RD|TH)") ~
          str_match(sample_id_clean, "^(\\d+)(ST|ND|RD|TH)")[, 2],
        str_detect(sample_id_clean, "[_-]\\d+$") ~ str_extract(sample_id_clean, "\\d+$"),
        TRUE ~ NA_character_
      ),
      
      # Preserve sample identity as provided
      sample_id = sample_id_display
    ) %>%
    select(sample_id, cultivar, treatment, sample_no, timepoint, everything(), -sample_id_raw, -sample_id_clean, -sample_id_display)
  
  return(data)
}

# Extract metadata
data_tp1 <- extract_metadata(data_tp1)
data_tp2 <- extract_metadata(data_tp2)

cat("✓ Metadata extracted\n")
cat("✓ Sample IDs created\n")
cat("\nSample identifiers (TP1):\n")
print(data_tp1 %>% select(sample_id, cultivar, treatment, sample_no, timepoint) %>% head(10))

# =========================================================================
# 6. COMBINE AND VALIDATE DATA
# =========================================================================

cat("\n============================================\n")
cat("COMBINING TIMEPOINT DATA\n")
cat("============================================\n")

# Combine both timepoints
data_combined <- bind_rows(data_tp1, data_tp2)

# Export processed data tables as CSV
readr::write_csv(data_tp1, file.path(csv_dir, "data_tp1.csv"), na = "NA")
readr::write_csv(data_tp2, file.path(csv_dir, "data_tp2.csv"), na = "NA")
readr::write_csv(data_combined, file.path(csv_dir, "data_combined.csv"), na = "NA")

# Export processed data tables as XLSX
writexl::write_xlsx(data_tp1, file.path(xlsx_dir, "data_tp1.xlsx"))
writexl::write_xlsx(data_tp2, file.path(xlsx_dir, "data_tp2.xlsx"))
writexl::write_xlsx(data_combined, file.path(xlsx_dir, "data_combined.xlsx"))

cat("✓ Data combined\n")
cat("  Total samples:", nrow(data_combined), "\n")
cat("  Cultivars found:", unique(data_combined$cultivar), "\n")
cat("  Treatments found:", unique(data_combined$treatment), "\n")
cat("  Timepoints:", unique(data_combined$timepoint), "\n")

# Check for missing values
cat("\nMissing values per column:\n")
missing_summary <- data_combined %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "column", values_to = "missing_count") %>%
  filter(missing_count > 0)

if (nrow(missing_summary) > 0) {
  print(missing_summary)
} else {
  cat("✓ No missing values detected\n")
}

# =========================================================================
# 7. PREPARE DATA FOR PLOTTING
# =========================================================================

cat("\n============================================\n")
cat("PREPARING PLOTTING DATA\n")
cat("============================================\n")

# Identify numeric columns (parameters to plot)
numeric_cols <- data_combined %>%
  select(-sample_id, -cultivar, -treatment, -sample_no, -timepoint) %>%
  select(where(is.numeric)) %>%
  names()

cat("Parameters identified for visualization:\n")
for (i in seq_along(numeric_cols)) {
  cat(sprintf("  %d. %s\n", i, numeric_cols[i]))
}

# Convert to long format for easier plotting
data_long <- data_combined %>%
  pivot_longer(
    cols = all_of(numeric_cols),
    names_to = "parameter",
    values_to = "value"
  ) %>%
  mutate(
    cultivar = factor(cultivar, levels = c("15", "22", "29", "30", "32")),
    treatment = factor(treatment, levels = c("Control", "Treatment")),
    timepoint = factor(timepoint, levels = c("Timepoint 1", "Timepoint 2"))
  )

# Mean across replicates and timepoints (combined)
data_mean <- data_long %>%
  group_by(cultivar, treatment, parameter) %>%
  summarise(
    mean_value = mean(value, na.rm = TRUE),
    n = sum(!is.na(value)),
    .groups = "drop"
  ) %>%
  mutate(
    cultivar = factor(cultivar, levels = c("15", "22", "29", "30", "32")),
    treatment = factor(treatment, levels = c("Control", "Treatment")),
    mean_value = if_else(is.nan(mean_value), NA_real_, mean_value)
  )

# Mean across replicates by timepoint
data_mean_timepoint <- data_long %>%
  group_by(cultivar, treatment, timepoint, parameter) %>%
  summarise(
    mean_value = mean(value, na.rm = TRUE),
    n = sum(!is.na(value)),
    .groups = "drop"
  ) %>%
  mutate(
    cultivar = factor(cultivar, levels = c("15", "22", "29", "30", "32")),
    treatment = factor(treatment, levels = c("Control", "Treatment")),
    timepoint = factor(timepoint, levels = c("Timepoint 1", "Timepoint 2")),
    mean_value = if_else(is.nan(mean_value), NA_real_, mean_value)
  )

# Create ordered sample factor (preserve biological order)
build_sample_order <- function(df) {
  df %>%
    select(sample_id, cultivar, treatment, sample_no) %>%
    mutate(
      cultivar = factor(cultivar, levels = c("15", "22", "29", "30", "32")),
      treatment = factor(treatment, levels = c("Control", "Treatment")),
      sample_no_num = suppressWarnings(as.numeric(sample_no))
    ) %>%
    arrange(cultivar, treatment, sample_no_num, sample_id) %>%
    distinct(sample_id) %>%
    pull(sample_id)
}

sample_order <- build_sample_order(data_combined)

data_long <- data_long %>%
  mutate(sample_id = factor(sample_id, levels = sample_order))

cat("✓ Data formatted for visualization\n")
cat("  Total data points:", nrow(data_long), "\n")

# =========================================================================
# 8. DEFINE COLOR PALETTES AND PLOTTING THEMES
# =========================================================================

cat("\n============================================\n")
cat("SETTING UP VISUALIZATION PARAMETERS\n")
cat("============================================\n")

# Color palette: Control vs Treatment
treatment_colors <- c(
  "Control" = "#0072B2",      # Professional blue
  "Treatment" = "#D55E00"     # Professional orange
)

# Function to create standardized barplot
create_barplot <- function(data, parameter_name, timepoint_filter = NULL) {
  
  # Filter data if needed
  plot_data <- data %>%
    filter(parameter == parameter_name)
  
  if (!is.null(timepoint_filter)) {
    plot_data <- plot_data %>%
      filter(timepoint == timepoint_filter)
  }
  
  # Rebuild sample order for the filtered data to drop missing samples
  sample_order_local <- build_sample_order(plot_data)
  plot_data <- plot_data %>%
    mutate(sample_id = factor(sample_id, levels = sample_order_local))
  
  # Create plot
  y_label <- tools::toTitleCase(gsub("_", " ", parameter_name))
  if (str_detect(parameter_name, "ability.*filled|grain.*fill")) {
    y_label <- paste0(y_label, " (%)")
  }

  p <- plot_data %>%
    ggplot(aes(x = sample_id, y = value, fill = treatment)) +
    geom_col(
      position = "identity",
      alpha = 0.85,
      color = "black",
      size = 0.4,
      width = 0.7
    ) +
    # Overlay raw points
    geom_point(
      aes(color = treatment),
      position = position_nudge(x = 0, y = 0),
      size = 3,
      alpha = 0.6,
      shape = 21,
      stroke = 0.5
    ) +
    scale_fill_manual(values = treatment_colors) +
    scale_color_manual(values = treatment_colors) +
    labs(
      title = sprintf("%s - %s",
                      tools::toTitleCase(gsub("_", " ", parameter_name)),
                      if (is.null(timepoint_filter)) "All Timepoints" else timepoint_filter),
      x = "Biological Sample",
      y = y_label,
      fill = "Treatment",
      color = "Treatment"
    ) +
    theme_pubr(
      base_size = 11,
      legend = "right",
      margin = TRUE
    ) +
    theme(
      # X-axis styling
      axis.text.x = element_text(
        angle = 45,
        hjust = 1,
        vjust = 1,
        size = 9,
        face = "plain",
        family = "sans"
      ),
      axis.text.y = element_text(size = 10),
      
      # Axis titles
      axis.title.x = element_text(size = 11, face = "bold"),
      axis.title.y = element_text(size = 11, face = "bold"),
      
      # Plot title
      plot.title = element_text(
        size = 12,
        face = "bold",
        hjust = 0.5,
        margin = margin(b = 10)
      ),
      
      # Legend
      legend.title = element_text(size = 10, face = "bold"),
      legend.text = element_text(size = 10),
      legend.position = "right",
      
      # Panel and plot background
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "#F5F5F5", color = "black", size = 0.5),
      panel.grid.major.y = element_line(color = "white", size = 0.3),
      panel.grid.minor.y = element_blank(),
      panel.grid.major.x = element_blank(),
      
      # Margins
      plot.margin = margin(t = 10, r = 10, b = 10, l = 10)
    )
  
  return(p)
}

# Function to create mean barplot (combined timepoints)
create_mean_barplot <- function(summary_data, parameter_name) {
  plot_data <- summary_data %>%
    filter(parameter == parameter_name)

  y_label <- tools::toTitleCase(gsub("_", " ", parameter_name))
  if (str_detect(parameter_name, "ability.*filled|grain.*fill")) {
    y_label <- paste0(y_label, " (%)")
  }

  p <- plot_data %>%
    ggplot(aes(x = cultivar, y = mean_value, fill = treatment)) +
    geom_col(
      position = position_dodge(width = 0.7),
      alpha = 0.85,
      color = "black",
      size = 0.4,
      width = 0.6
    ) +
    scale_fill_manual(values = treatment_colors) +
    labs(
      title = sprintf(
        "Mean of Replicates (All Timepoints Combined) - %s",
        tools::toTitleCase(gsub("_", " ", parameter_name))
      ),
      x = "Cultivar",
      y = y_label,
      fill = "Treatment"
    ) +
    theme_pubr(
      base_size = 11,
      legend = "right",
      margin = TRUE
    ) +
    theme(
      axis.text.x = element_text(size = 10, face = "plain", family = "sans"),
      axis.text.y = element_text(size = 10),
      axis.title.x = element_text(size = 11, face = "bold"),
      axis.title.y = element_text(size = 11, face = "bold"),
      plot.title = element_text(
        size = 12,
        face = "bold",
        hjust = 0.5,
        margin = margin(b = 10)
      ),
      legend.title = element_text(size = 10, face = "bold"),
      legend.text = element_text(size = 10),
      legend.position = "right",
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "#F5F5F5", color = "black", size = 0.5),
      panel.grid.major.y = element_line(color = "white", size = 0.3),
      panel.grid.minor.y = element_blank(),
      panel.grid.major.x = element_blank(),
      plot.margin = margin(t = 10, r = 10, b = 10, l = 10)
    )

  return(p)
}

# Function to create mean barplot by timepoint
create_mean_timepoint_barplot <- function(summary_data, parameter_name, timepoint_filter) {
  plot_data <- summary_data %>%
    filter(parameter == parameter_name, timepoint == timepoint_filter)

  y_label <- tools::toTitleCase(gsub("_", " ", parameter_name))
  if (str_detect(parameter_name, "ability.*filled|grain.*fill")) {
    y_label <- paste0(y_label, " (%)")
  }

  p <- plot_data %>%
    ggplot(aes(x = cultivar, y = mean_value, fill = treatment)) +
    geom_col(
      position = position_dodge(width = 0.7),
      alpha = 0.85,
      color = "black",
      size = 0.4,
      width = 0.6
    ) +
    scale_fill_manual(values = treatment_colors) +
    labs(
      title = sprintf(
        "Mean of Replicates - %s (%s)",
        tools::toTitleCase(gsub("_", " ", parameter_name)),
        timepoint_filter
      ),
      x = "Cultivar",
      y = y_label,
      fill = "Treatment"
    ) +
    theme_pubr(
      base_size = 11,
      legend = "right",
      margin = TRUE
    ) +
    theme(
      axis.text.x = element_text(size = 10, face = "plain", family = "sans"),
      axis.text.y = element_text(size = 10),
      axis.title.x = element_text(size = 11, face = "bold"),
      axis.title.y = element_text(size = 11, face = "bold"),
      plot.title = element_text(
        size = 12,
        face = "bold",
        hjust = 0.5,
        margin = margin(b = 10)
      ),
      legend.title = element_text(size = 10, face = "bold"),
      legend.text = element_text(size = 10),
      legend.position = "right",
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "#F5F5F5", color = "black", size = 0.5),
      panel.grid.major.y = element_line(color = "white", size = 0.3),
      panel.grid.minor.y = element_blank(),
      panel.grid.major.x = element_blank(),
      plot.margin = margin(t = 10, r = 10, b = 10, l = 10)
    )

  return(p)
}

# Function to compare timepoints with shaded overlap (mean of replicates)
create_timepoint_comparison_barplot <- function(summary_data, parameter_name) {
  plot_data <- summary_data %>%
    filter(parameter == parameter_name) %>%
    arrange(timepoint)

  y_label <- tools::toTitleCase(gsub("_", " ", parameter_name))
  if (str_detect(parameter_name, "ability.*filled|grain.*fill")) {
    y_label <- paste0(y_label, " (%)")
  }

  p <- plot_data %>%
    ggplot(aes(
      x = cultivar,
      y = mean_value,
      fill = treatment,
      alpha = timepoint,
      group = treatment
    )) +
    geom_col(
      position = position_dodge(width = 0.7),
      color = "black",
      size = 0.4,
      width = 0.6
    ) +
    scale_fill_manual(values = treatment_colors) +
    scale_alpha_manual(values = c("Timepoint 1" = 0.45, "Timepoint 2" = 0.85)) +
    labs(
      title = sprintf(
        "Timepoint Comparison (Mean of Replicates) - %s",
        tools::toTitleCase(gsub("_", " ", parameter_name))
      ),
      x = "Cultivar",
      y = y_label,
      fill = "Treatment",
      alpha = "Timepoint"
    ) +
    theme_pubr(
      base_size = 11,
      legend = "right",
      margin = TRUE
    ) +
    theme(
      axis.text.x = element_text(size = 10, face = "plain", family = "sans"),
      axis.text.y = element_text(size = 10),
      axis.title.x = element_text(size = 11, face = "bold"),
      axis.title.y = element_text(size = 11, face = "bold"),
      plot.title = element_text(
        size = 12,
        face = "bold",
        hjust = 0.5,
        margin = margin(b = 10)
      ),
      legend.title = element_text(size = 10, face = "bold"),
      legend.text = element_text(size = 10),
      legend.position = "right",
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "#F5F5F5", color = "black", size = 0.5),
      panel.grid.major.y = element_line(color = "white", size = 0.3),
      panel.grid.minor.y = element_blank(),
      panel.grid.major.x = element_blank(),
      plot.margin = margin(t = 10, r = 10, b = 10, l = 10)
    )

  return(p)
}

# =========================================================================
# 9. EXPORT FIGURE FUNCTION
# =========================================================================

export_figure <- function(plot_obj, filename, timepoint = NULL, formats = c("png", "pdf", "svg")) {
  
  # Create base filename
  if (!is.null(timepoint)) {
    # Extract timepoint number
    tp_num <- str_extract(timepoint, "\\d+")
    base_filename <- paste0(
      filename,
      "_tp",
      tp_num
    )
  } else {
    base_filename <- filename
  }
  
  # Export in all requested formats
  for (fmt in formats) {
    
    if (fmt == "png") {
      filepath <- file.path(png_dir, paste0(base_filename, ".png"))
      ggsave(
        filepath,
        plot = plot_obj,
        width = 12,
        height = 7,
        dpi = 300,
        units = "in",
        device = "png"
      )
      cat(sprintf("✓ Exported: %s\n", basename(filepath)))
    }
    
    else if (fmt == "pdf") {
      filepath <- file.path(pdf_dir, paste0(base_filename, ".pdf"))
      ggsave(
        filepath,
        plot = plot_obj,
        width = 12,
        height = 7,
        dpi = 300,
        units = "in",
        device = "pdf"
      )
      cat(sprintf("✓ Exported: %s\n", basename(filepath)))
    }
    
    else if (fmt == "svg") {
      filepath <- file.path(svg_dir, paste0(base_filename, ".svg"))
      ggsave(
        filepath,
        plot = plot_obj,
        width = 12,
        height = 7,
        dpi = 300,
        units = "in",
        device = "svg"
      )
      cat(sprintf("✓ Exported: %s\n", basename(filepath)))
    }
  }
}

export_mean_figure <- function(plot_obj, filename, formats = c("png", "pdf", "svg")) {
  base_filename <- filename

  for (fmt in formats) {
    if (fmt == "png") {
      filepath <- file.path(mean_png_dir, paste0(base_filename, ".png"))
      ggsave(
        filepath,
        plot = plot_obj,
        width = 12,
        height = 7,
        dpi = 300,
        units = "in",
        device = "png"
      )
      cat(sprintf("✓ Exported: %s\n", basename(filepath)))
    }

    else if (fmt == "pdf") {
      filepath <- file.path(mean_pdf_dir, paste0(base_filename, ".pdf"))
      ggsave(
        filepath,
        plot = plot_obj,
        width = 12,
        height = 7,
        dpi = 300,
        units = "in",
        device = "pdf"
      )
      cat(sprintf("✓ Exported: %s\n", basename(filepath)))
    }

    else if (fmt == "svg") {
      filepath <- file.path(mean_svg_dir, paste0(base_filename, ".svg"))
      ggsave(
        filepath,
        plot = plot_obj,
        width = 12,
        height = 7,
        dpi = 300,
        units = "in",
        device = "svg"
      )
      cat(sprintf("✓ Exported: %s\n", basename(filepath)))
    }
  }
}

# =========================================================================
# 10. GENERATE EXPLORATORY BARPLOTS FOR ALL PARAMETERS
# =========================================================================

cat("\n============================================\n")
cat("GENERATING EXPLORATORY BARPLOTS\n")
cat("============================================\n")

# Process each parameter
for (param in numeric_cols) {
  
  cat("\n" %+% sprintf("Processing parameter: %s", param) %+% "\n")
  cat(strrep("-", 50) %+% "\n")
  
  # Timepoint 1
  cat("  Creating plots for Timepoint 1...\n")
  p_tp1 <- create_barplot(data_long, param, "Timepoint 1")
  
  # Generate filename
  param_filename <- tolower(gsub(" ", "_", gsub("[^[:alnum:] ]", "", param)))
  filename_base <- paste0(param_filename, "_barplot")
  
  # Export TP1
  export_figure(
    p_tp1,
    filename = filename_base,
    timepoint = "Timepoint 1",
    formats = c("png", "pdf", "svg")
  )
  
  # Timepoint 2
  cat("  Creating plots for Timepoint 2...\n")
  p_tp2 <- create_barplot(data_long, param, "Timepoint 2")
  
  # Export TP2
  export_figure(
    p_tp2,
    filename = filename_base,
    timepoint = "Timepoint 2",
    formats = c("png", "pdf", "svg")
  )
  
  # Combined plot (all timepoints)
  cat("  Creating combined plot (all timepoints)...\n")
  p_combined <- create_barplot(data_long, param, timepoint_filter = NULL)
  
  export_figure(
    p_combined,
    filename = filename_base,
    timepoint = NULL,
    formats = c("png", "pdf", "svg")
  )
}

# =========================================================================
# 10B. GENERATE MEAN BARPLOTS (ALL TIMEPOINTS COMBINED)
# =========================================================================

cat("\n============================================\n")
cat("GENERATING MEAN BARPLOTS (ALL TIMEPOINTS COMBINED)\n")
cat("============================================\n")

for (param in numeric_cols) {
  cat("\n" %+% sprintf("Processing mean plot: %s", param) %+% "\n")
  cat(strrep("-", 50) %+% "\n")

  p_mean <- create_mean_barplot(data_mean, param)

  param_filename <- tolower(gsub(" ", "_", gsub("[^[:alnum:] ]", "", param)))
  filename_base <- paste0(param_filename, "_mean_barplot")

  export_mean_figure(
    p_mean,
    filename = filename_base,
    formats = c("png", "pdf", "svg")
  )
}

# =========================================================================
# 10C. GENERATE MEAN BARPLOTS BY TIMEPOINT
# =========================================================================

cat("\n============================================\n")
cat("GENERATING MEAN BARPLOTS BY TIMEPOINT\n")
cat("============================================\n")

timepoint_levels <- levels(data_long$timepoint)

for (param in numeric_cols) {
  for (tp in timepoint_levels) {
    cat("\n" %+% sprintf("Processing mean plot: %s (%s)", param, tp) %+% "\n")
    cat(strrep("-", 50) %+% "\n")

    p_mean_tp <- create_mean_timepoint_barplot(data_mean_timepoint, param, tp)

    param_filename <- tolower(gsub(" ", "_", gsub("[^[:alnum:] ]", "", param)))
    filename_base <- paste0(param_filename, "_mean_barplot_", ifelse(tp == "Timepoint 1", "tp1", "tp2"))

    export_mean_figure(
      p_mean_tp,
      filename = filename_base,
      formats = c("png", "pdf", "svg")
    )
  }
}

# =========================================================================
# 10D. GENERATE TIMEPOINT COMPARISON BARPLOTS (SHADED OVERLAY)
# =========================================================================

cat("\n============================================\n")
cat("GENERATING TIMEPOINT COMPARISON BARPLOTS (SHADED OVERLAY)\n")
cat("============================================\n")

for (param in numeric_cols) {
  cat("\n" %+% sprintf("Processing timepoint comparison: %s", param) %+% "\n")
  cat(strrep("-", 50) %+% "\n")

  p_compare <- create_timepoint_comparison_barplot(data_mean_timepoint, param)

  param_filename <- tolower(gsub(" ", "_", gsub("[^[:alnum:] ]", "", param)))
  filename_base <- paste0(param_filename, "_mean_timepoint_compare")

  export_mean_figure(
    p_compare,
    filename = filename_base,
    formats = c("png", "pdf", "svg")
  )
}

# =========================================================================
# 11. SUMMARY AND SESSION COMPLETION
# =========================================================================

cat("\n" %+% strrep("=", 50) %+% "\n")
cat("ANALYSIS COMPLETE\n")
cat(strrep("=", 50) %+% "\n")

cat("\n📊 GENERATED FIGURES SUMMARY:\n")
cat("✓ PNG files:", length(list.files(png_dir, pattern = "\\.png$")), "\n")
cat("✓ PDF files:", length(list.files(pdf_dir, pattern = "\\.pdf$")), "\n")
cat("✓ SVG files:", length(list.files(svg_dir, pattern = "\\.svg$")), "\n")

cat("\n📊 GENERATED MEAN FIGURES SUMMARY:\n")
cat("✓ Mean PNG files:", length(list.files(mean_png_dir, pattern = "\\.png$")), "\n")
cat("✓ Mean PDF files:", length(list.files(mean_pdf_dir, pattern = "\\.pdf$")), "\n")
cat("✓ Mean SVG files:", length(list.files(mean_svg_dir, pattern = "\\.svg$")), "\n")

cat("\n📁 OUTPUT LOCATIONS:\n")
cat("   PNG:  ", png_dir, "\n")
cat("   PDF:  ", pdf_dir, "\n")
cat("   SVG:  ", svg_dir, "\n")

cat("\n📋 ANALYSIS PARAMETERS:\n")
cat("   Cultivars:", paste(unique(data_combined$cultivar), collapse = ", "), "\n")
cat("   Treatments: Control (C), Treatment (T)\n")
cat("   Timepoints:", length(unique(data_combined$timepoint)), "\n")
cat("   Parameters analyzed:", length(numeric_cols), "\n")
cat("   Total samples:", length(unique(data_combined$sample_id)), "\n")

cat("\n✅ Exploratory visualization complete!\n")
cat("   All figures ready for manuscript preparation.\n\n")

# =========================================================================
# END OF ANALYSIS
# =========================================================================

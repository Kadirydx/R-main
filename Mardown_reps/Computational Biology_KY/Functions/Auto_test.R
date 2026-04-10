auto_test <- function(data, var1, var2 = NULL) {
  var1_type <- class(data[[var1]])
  var2_type <- if (!is.null(var2)) class(data[[var2]]) else NULL
  
  # Faktor dönüşümünü tek bir yerde yapıyoruz
  if (var1_type == "character") {
    data[[var1]] <- factor(data[[var1]])
    var1_type <- "factor"
  }
  
  if (!is.null(var2) && var2_type == "character") {
    data[[var2]] <- factor(data[[var2]])
    var2_type <- "factor"
  }
  
  # Şimdi, testleri yapalım
  if (is.null(var2)) {
    if (var1_type %in% c("numeric", "integer")) {
      cat("Shapiro-Wilk Test for normality is being performed...\n")
      result <- shapiro.test(data[[var1]])
    } else if (var1_type == "factor") {
      cat("Chi-Square Goodness-of-Fit Test is being performed...\n")
      result <- chisq.test(table(data[[var1]]))
    } else {
      stop("Unrecognized variable type for single-variable test.")
    }
  } else {
    # İki değişkenli testler
    shapiro_var1 <- shapiro.test(data[[var1]])$p.value
    shapiro_var2 <- shapiro.test(data[[var2]])$p.value
    
    if (var1_type %in% c("numeric", "integer") && var2_type %in% c("numeric", "integer")) {
      cat("Correlation test is being performed...\n")
      if (shapiro_var1 > 0.05 && shapiro_var2 > 0.05) {
        result <- cor.test(data[[var1]], data[[var2]], method = "pearson")
      } else {
        result <- cor.test(data[[var1]], data[[var2]], method = "spearman")
      }
    }
    
    else if (var1_type == "factor" && var2_type %in% c("numeric", "integer")) {
      levels_count <- length(levels(data[[var1]]))
      if (levels_count == 2) {
        cat("Independent T-Test (or Wilcoxon) is being performed...\n")
        if (shapiro_var2 > 0.05) {
          result <- t.test(data[[var2]] ~ data[[var1]], data = data)
        } else {
          result <- wilcox.test(data[[var2]] ~ data[[var1]], data = data)
        }
      } else if (levels_count > 2) {
        cat("ANOVA (or Kruskal-Wallis Test) is being performed...\n")
        if (shapiro_var2 > 0.05) {
          result <- aov(data[[var2]] ~ data[[var1]], data = data)
        } else {
          result <- kruskal.test(data[[var2]] ~ data[[var1]], data = data)
        }
      }
    }
    
    else if (var2_type == "factor" && var1_type %in% c("numeric", "integer")) {
      levels_count <- length(levels(data[[var2]]))
      if (levels_count == 2) {
        cat("Independent T-Test (or Wilcoxon) is being performed...\n")
        if (shapiro_var1 > 0.05) {
          result <- t.test(data[[var1]] ~ data[[var2]], data = data)
        } else {
          result <- wilcox.test(data[[var1]] ~ data[[var2]], data = data)
        }
      } else if (levels_count > 2) {
        cat("ANOVA (or Kruskal-Wallis Test) is being performed...\n")
        if (shapiro_var1 > 0.05) {
          result <- aov(data[[var1]] ~ data[[var2]], data = data)
        } else {
          result <- kruskal.test(data[[var1]] ~ data[[var2]], data = data)
        }
      }
    }
    
    else if (var1_type == "factor" && var2_type == "factor") {
      cat("Chi-Square Test for independence is being performed...\n")
      result <- chisq.test(table(data[[var1]], data[[var2]]))
    }
    
    else {
      stop("Variable types are not compatible for statistical tests.")
    }
  }
  
  return(result)
}

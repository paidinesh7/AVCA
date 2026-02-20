#!/bin/bash
# Portfolio Tracker - New File Detection Script
# Compares files on disk against the processed tracker in CLAUDE.md
# Scans both portfolio company folders and Deal Flow pitch folders
# Usage: bash detect_new_files.sh

ROOT="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_MD="$ROOT/CLAUDE.md"

echo "==================================="
echo "Portfolio Tracker - New File Detector"
echo "==================================="
echo ""

if [ ! -f "$CLAUDE_MD" ]; then
    echo "ERROR: CLAUDE.md not found at $CLAUDE_MD"
    echo "Make sure you're running this from the portfolio-tracker directory."
    exit 1
fi

# ---- PASS 1: Portfolio company files ----
portfolio_count=0

while IFS= read -r filepath; do
    relpath="${filepath#$ROOT/}"
    filename=$(basename "$filepath")

    if grep -qF "$filename" "$CLAUDE_MD" 2>/dev/null; then
        : # Already tracked
    else
        if [ $portfolio_count -eq 0 ]; then
            echo "PORTFOLIO UPDATES:"
            echo "-----------------------------------"
        fi
        portfolio_count=$((portfolio_count + 1))
        size=$(du -h "$filepath" | cut -f1)
        moddate=$(date -r "$filepath" "+%Y-%m-%d %H:%M" 2>/dev/null || stat -c "%y" "$filepath" 2>/dev/null | cut -d. -f1)
        echo "  [$portfolio_count] $relpath"
        echo "      Size: $size | Modified: $moddate"
        echo ""
    fi
done < <(find "$ROOT" -type f \
    -not -path "*/Claude Summary/*" \
    -not -path "*/Deal Flow/*" \
    -not -path "*/.claude/*" \
    -not -path "*/.git/*" \
    -not -name "CLAUDE.md" \
    -not -name "README.md" \
    -not -name "detect_new_files.sh" \
    -not -name ".gitignore" \
    -not -name ".*" \
    | sort)

if [ $portfolio_count -eq 0 ]; then
    echo "PORTFOLIO UPDATES: None — all files tracked."
fi

echo ""

# ---- PASS 2: Deal Flow pitch files ----
dealflow_count=0

if [ -d "$ROOT/Deal Flow" ]; then
    while IFS= read -r filepath; do
        relpath="${filepath#$ROOT/}"
        filename=$(basename "$filepath")

        if grep -qF "$filename" "$CLAUDE_MD" 2>/dev/null; then
            : # Already tracked
        else
            if [ $dealflow_count -eq 0 ]; then
                echo "DEAL FLOW / PITCHES:"
                echo "-----------------------------------"
            fi
            dealflow_count=$((dealflow_count + 1))
            size=$(du -h "$filepath" | cut -f1)
            moddate=$(date -r "$filepath" "+%Y-%m-%d %H:%M" 2>/dev/null || stat -c "%y" "$filepath" 2>/dev/null | cut -d. -f1)
            echo "  [$dealflow_count] $relpath"
            echo "      Size: $size | Modified: $moddate"
            echo ""
        fi
    done < <(find "$ROOT/Deal Flow" -type f \
        -not -name "README.md" \
        -not -name ".*" \
        | sort)

    if [ $dealflow_count -eq 0 ]; then
        echo "DEAL FLOW / PITCHES: None — all pitches tracked."
    fi
else
    echo "DEAL FLOW / PITCHES: Deal Flow/ directory not found. Create it to start evaluating pitches."
fi

echo ""

# ---- Summary ----
total=$((portfolio_count + dealflow_count))

if [ $total -eq 0 ]; then
    echo "==================================="
    echo "All files are tracked. No new updates or pitches found."
else
    echo "==================================="
    echo "Total new files: $total (portfolio: $portfolio_count, pitches: $dealflow_count)"
    echo ""
    if [ $portfolio_count -gt 0 ]; then
        echo "To process portfolio updates, start Claude and say:"
        echo "  'Process the new updates'"
    fi
    if [ $dealflow_count -gt 0 ]; then
        echo "To evaluate pitches, start Claude and say:"
        echo "  'Evaluate the new pitches'"
    fi
fi

echo ""
echo "Last run: $(date '+%Y-%m-%d %H:%M:%S')"

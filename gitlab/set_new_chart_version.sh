grep "chart_version: 0.6.26" -rl **/**/inventory.yml | xargs sed -i 's/chart_version: 0.6.26/chart_version: 0.7.1/g'

grep "jms_version: 5.17.0-jdbc" -rl */*/inventory.yml | xargs sed -i 's/jms_version: .*/jms_version: 5.17.5-jdbc/g'


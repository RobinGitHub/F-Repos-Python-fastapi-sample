#! /usr/bin/env sh
# 用于执行迁移
echo "Running inside /app/prestart.sh, you could add migrations to this file, e.g.:"

echo "
#! /usr/bin/env sh

# Let the DB start
sleep 10;
# Run migrations
# alembic upgrade head
"

echo "test"

# 启动之前运行其他脚本
# Run custom Python script before starting
#python /app/my_custom_prestart_script.py
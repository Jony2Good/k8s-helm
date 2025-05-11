#!/usr/bin/env bash
# Кэширование конфигурации, маршрутов и представлений
php artisan migrate --force
php artisan db:seed
php artisan route:clear
php artisan route:cache
php artisan cache:clear
php artisan config:clear
php artisan config:cache
php artisan view:clear
php artisan view:cache

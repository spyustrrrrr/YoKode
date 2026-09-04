# gunakan pondasi sistem operasi yang sudah terinstal PHP 8.2 dan web server apache
FROM php:8.2-apache

# install alat alat sostem linux dasar yang dibutuhkan oleh laravel
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# bersihkan sampah instalasi agar ukuran kontainer tidak bengkak
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# isntall ekstensi bahasa PHP tambahan yang diwajibkan oleh laravel
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# pinjamkan mesin composer dari luar untuk mengurus folder vendor
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# tentukan di folder mana kita akan bekerja di dalam kontainer ini
WORKDIR /var/www/html

# salin seluruh file kode LMS Yokode dari laptop kedalam kontainer
COPY . .

# suruh mesin composer mengunduh semua library ( membuat folder vendor )
RUN composer install --optimize-autoloader --no-dev

# berikan hak akses kepada apache agar bisa membuat file log dan cache di laravel
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# aktifkan fitur rewrite apache agar sistem routing laravel bisa berfungsi
RUN a2enmod rewrite

# bula pintu port 80 agar bisa diakses dari luar
EXPOSE 80

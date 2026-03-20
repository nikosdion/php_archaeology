# Docker LAMP Stack for PHP Archaeology

A Docker-based server stack for running **old** sites locally.

## The reason of its existence

If you have a backup of an ancient site, you will have a hard time restoring it on a commercial host, or a regular local server environment. Your server environment has a PHP and database server version that's too new for, and incompatible with, the old site.

Using the containerised server stack in this repository, you can go as old as Apache 2.0 with PHP 5.6 and MySQL 5.5 – or as modern as the very latest versions. This allows you to restore very old sites. You can then upgrade the PHP and MySQL versions as you go through increasingly newer versions of your web software (e.g. Joomla, WordPress, …). Do so until you reach the point where you have an up-to-date site running on a modern stack that matches your live host. Then, you can take a backup using [Akeeba Backup](https://extensions.joomla.org/extension/akeeba-backup/) —or any other method you are familiar with— and deploy it to your live host.

## Supported environments

This containerised server is developed and tested on Arch Linux. Further testing sporadically takes place under Debian and macOS.

The intention is that this should run under one of the following environments:

* Linux (Debian, Ubuntu, Arch Linux, …)
* Windows Subsystem for Linux 2 (WSL2)
* macOS

It should also run under BSD on the basis that macOS is a BSD userspace with a Mach kernel, and things work fine there.

## Usage (simplified)

Copy the file `env.sample` to `.env` and edit it.

The easiest way to bring the server up is to run `./up` from the root of this repository. 

Conversely, you can run `./down` to bring it down. Please note that this **destroys** the server containers, but your data stays behind. 

If you want to stop the server without destroying the server containers –therefore saving you time when you want to restart the server later– use `docker compose stop`. Start the server again with `docker compose start`.

## Usage (Docker Compose)

> [!IMPORTANT]
> The `up` and `down` scripts will probably not run on WSL / WSL2 on Windows due to the idiosyncratic way Windows handles ownership and permissions between the host filesystem, the Hyper-V VM that runs the Docker Engine, and the containers. It's best to go the direct Docker route through Powershell. That said, I haven't used Windows in years; please don't ask me for help using this on Windows.

If you prefer a more direct approach, you can run `docker compose up --build --detach --remove-orphans` to bring the server up.

If you want to stop the server without destroying the server containers –therefore saving you time when you want to restart the server later– use `docker compose stop`. Start the server again with `docker compose start`.

To bring the server down, deleting the containers, use `docker compose down --remove-orphans`. Your data stays behind. Remember to delete the `mysql/data` directory (on Linux or macOS you will need to do `sudo rm mysql/data`).

If you are on Linux and macOS, remember that the container runs under a different user than your login user. You will have to `chown` the files and directories you put inside `public_html` if you want in-place extension/ plugin installation and core / plugin / extensions update to work in Joomla and WordPress.

You cannot switch between MySQL to MariaDB or between different versions of MySQL / MariaDB in place. Take a backup of your database, bring the server down, edit your `.env`, bring the server up, and restore your database backup. I recommend that you use Akeeba Backup (for Joomla and WordPress) or Akeeba Solo (for anything else) to back up and restore your site. Its restoration script automatically handles the differences between different versions of MySQL and MariaDB.

## Default connection information

If you are using the default settings: 

* PHP 5.6, Apache 2.4, MySQL 5.5
* Access your site at `http://localhost:4280` or `https://localhost:4443` (self-signed SSL certificate).
* Access the Mailhog (email cather) interface at `http://localhost:4225`
* The site's files are under the `public_html` folder of this repository. 
* The MySQL database files are under the `mysql/data` folder of this repository.
* Regular MySQL connection information, use with your site:
  * **Hostname** `mysql`
  * **Username** `mysite`
  * **Password** `2aZzXMhJMGayLYBq6rjJcB9k`
  * **Database name** `mysite`
* Root MySQL connection information, use from your computer (e.g. Beekeeper Studio, HeidiSQL, phpStorm, Sequel Ace, …):
    * **Hostname** `localhost:4236`
    * **Username** `root`
    * **Password** `MBC7ktXWaq8KNVVP3K36SALa`

## Credits

Originally based on the blog post “[Running your LAMP Stack on Docker Containers](https://blog.tkav.dev/running-your-lamp-stack-on-docker-containers)”
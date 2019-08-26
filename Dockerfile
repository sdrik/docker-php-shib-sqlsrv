FROM sdrik/php-shib

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		apt-transport-https \
		gnupg \
	&& curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
	&& curl https://packages.microsoft.com/config/debian/10/prod.list \
		> /etc/apt/sources.list.d/mssql-release.list \
	&& apt-get update \
	&& DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
		unixodbc-dev \
		msodbcsql17 \
		krb5-user \
		openssh-client \
		libnss-sss \
		git \
	&& pecl install sqlsrv pdo_sqlsrv \
	&& docker-php-ext-enable sqlsrv pdo_sqlsrv \
	&& rm -rf /var/lib/apt/lists/*

# workaround for https://github.com/microsoft/msphpsql/issues/1021
RUN sed -i -E 's/(CipherString\s*=\s*DEFAULT@SECLEVEL=)2/\11/' /etc/ssl/openssl.cnf

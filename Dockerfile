FROM centos:7
MAINTAINER James Wade <jpswade@gmail.com>

ADD http://pkg.jenkins-ci.org/redhat/jenkins.repo /etc/yum.repos.d/jenkins.repo
RUN rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key && \
    yum install -y initscripts php-intl phpunit java jenkins ant wget php-pear git
RUN pear install PHP_CodeSniffer && \
    wget https://phar.phpunit.de/phploc.phar && chmod +x phploc.phar && mv phploc.phar /usr/local/bin/phploc && \
    curl -s https://api.github.com/repos/pdepend/pdepend/releases/latest | grep "browser_download_url.*phar" | cut -d : -f 2,3 | tr -d \" | wget -i - -O pdepend.phar --no-check-certificate && \
    chmod +x pdepend.phar && mv pdepend.phar /usr/local/bin/pdepend && \
    wget https://phpmd.org/static/latest/phpmd.phar --no-check-certificate && chmod +x phpmd.phar && mv phpmd.phar /usr/local/bin/phpmd && \
    wget https://phar.phpunit.de/phpcpd.phar && chmod +x phpcpd.phar && mv phpcpd.phar /usr/local/bin/phpcpd && \
    curl -s https://api.github.com/repos/theseer/phpdox/releases/latest | grep "browser_download_url.*phar" | cut -d : -f 2,3 | tr -d \" | wget -i - -O phpdox.phar --no-check-certificate && chmod +x phpdox.phar && mv phpdox.phar /usr/local/bin/phpdox

ADD setup.sh /setup.sh
ADD example.xml /example.xml
RUN sh /setup.sh

EXPOSE 8080

CMD service jenkins start && tail -f /var/log/jenkins/jenkins.log

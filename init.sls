include:
  - elastic-repo

# Install filebeat rpm
filebeat-pkg:
  pkg.installed:
    - name: filebeat
    - require:
      - sls: elastic-repo

# Manage the filebeat config files
/etc/filebeat/files/filebeat.yml:
  file.managed:
    - source: salt://filebeat/files/filebeat.yml.jinja
    - user: root
    - group: root
    - mode: 0600
    - template: jinja
    - require:
      - pkg: filebeat

/etc/filebeat/modules.d/bw-apache2.yml:
  file.managed:
    - source: salt://filebeat/files/bw-apache2.yml
    - user: root
    - group: root
    - mode: 0600
    - require:
      - pkg: filebeat

# Manage the filebeat service
filebeat-agent-service:
  service:
    - name: filebeat
    - running
    - enable: True
    - require:
      - file: /etc/filebeat/filebeat.yml
    - watch:
      - file: /etc/filebeat/filebeat.yml

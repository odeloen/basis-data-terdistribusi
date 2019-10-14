CREATE USER 'monitor'@'%' IDENTIFIED BY 'monitorpassword';
GRANT SELECT on sys.* to 'monitor'@'%';
FLUSH PRIVILEGES;

CREATE USER 'simkpuser'@'%' IDENTIFIED BY 'simkppassword';
GRANT ALL PRIVILEGES on simkp.* to 'simkpuser'@'%';
FLUSH PRIVILEGES;
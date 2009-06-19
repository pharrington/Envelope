CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `email` varchar(65) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `persistence_token` varchar(255) NOT NULL,
  `attachment_dir` varchar(12) default NULL,
  PRIMARY KEY  (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('20090414211517');

INSERT INTO schema_migrations (version) VALUES ('20090414232540');

INSERT INTO schema_migrations (version) VALUES ('20090425191920');
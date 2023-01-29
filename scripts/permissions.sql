insert into public.users (id, username, password, password_iterations, password_salt, algorithm)
values
  (1, 'backend', 'wtUo2dri+ttHGHRpngg9uG21piWLiKSX7IaNSnU/BfN9pt+ZOLQByG/3JlPPQ7t/pl8S3tjR2+Um/DPBdAQULg==', 100, 'Nv6NU9XY7tvHdSGaKmNTOw==', 'SHA512'),
  (2, 'client', 'ZHg/rNJel1BHOYMEvc40ekCRUE5vVLcsPF6mk9GPDcdEmX3stm50MplaqjGb8Lxhy6rNFQZSQRSbOxmFZ8ps1Q==', 100, 'JhpW27QU9WfIaG6FJT5MkQ==', 'SHA512'),
  (3, 'admin', 'nOgr9xVnkt51Lr68KS/rAKm/LqxAt8oEki7vCerRod3qDbyMFfDBGT8obnkw+AGygxCQDWdaA2sQnXXoAbVK6Q==', 100, 'wxw+3diCV4bWXQHb6LLniA==', 'SHA512');
insert into public.permissions (id, topic, publish_allowed, subscribe_allowed, qos_0_allowed, qos_1_allowed, qos_2_allowed, retained_msgs_allowed, shared_sub_allowed, shared_group)
values
  (1, '+/status', false, true, true, true, true, false, false, ''),
  (2, '${mqtt-clientid}/status', true, false, true, true, true, true, false, ''),
  (3, '#', true, true, true, true, true, true, true, '');
insert into public.roles (id, name, description)
values
  (1, 'backend', 'only allowed to subscribe to topics'),
  (2, 'client', 'only allowed to publish to topics'),
  (3, 'admin', 'is allowed to do everything');
insert into public.user_roles (user_id, role_id)
values
  (1, 1),
  (2, 2),
  (3, 3);
insert into public.role_permissions (role, permission)
values
  (1, 1),
  (2, 2),
  (3, 3);
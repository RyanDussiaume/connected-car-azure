insert into public.users (id, username, password, password_iterations, password_salt, algorithm)
values
  (1, 'admin', 'nOgr9xVnkt51Lr68KS/rAKm/LqxAt8oEki7vCerRod3qDbyMFfDBGT8obnkw+AGygxCQDWdaA2sQnXXoAbVK6Q==', 100, 'wxw+3diCV4bWXQHb6LLniA==', 'SHA512'),
  (2, 'vehicle1', 'W+0LP4z8dWwbuqy3553i/UEKYMqfeVHtNvZLUCwn3/Q/RSjg/yOnr1om7vNmGcqvP3NYXgLeKLIO/bhVMv/4MQ==', 100, '', 'SHA512'),
  (3, 'vehicle2', 'W+0LP4z8dWwbuqy3553i/UEKYMqfeVHtNvZLUCwn3/Q/RSjg/yOnr1om7vNmGcqvP3NYXgLeKLIO/bhVMv/4MQ==', 100, '', 'SHA512'),
  (4, 'vehicle3', 'W+0LP4z8dWwbuqy3553i/UEKYMqfeVHtNvZLUCwn3/Q/RSjg/yOnr1om7vNmGcqvP3NYXgLeKLIO/bhVMv/4MQ==', 100, '', 'SHA512');
insert into public.permissions (id, topic, publish_allowed, subscribe_allowed, qos_0_allowed, qos_1_allowed, qos_2_allowed, retained_msgs_allowed, shared_sub_allowed, shared_group)
values
  (1, '#', true, true, true, true, true, true, true, ''),
  (2, 'telemetry/${mqtt-clientid}', true, false, true, true, true, true, false, '');
insert into public.roles (id, name, description)
values
  (1, 'admin', 'is allowed to do everything'),
  (2, 'client', 'only allowed to publish to topics');
insert into public.user_roles (user_id, role_id)
values
  (1, 1),
  (2, 2),
  (3, 2),
  (4, 2);
insert into public.role_permissions (role, permission)
values
  (1, 1),
  (2, 2);
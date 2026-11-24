-- OPCIONAL: Corrige textos previamente gravados com caracteres corrompidos.
-- Aplica somente aos treinos planejados da conta B; não altera o usuário A.
-- Não modifica treinos realizados, metas ou histórico.
BEGIN;
UPDATE public.planned_workout_overrides
SET description = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(description, 'â€“', '–'), 'â€”', '—'), 'â€™', '’'), 'Ã§', 'ç'), 'Ã£', 'ã'), 'Ãµ', 'õ'), 'Ã¡', 'á'), 'Ã©', 'é'), 'Ã­', 'í'), 'Ã³', 'ó'), 'Ãº', 'ú'), 'Ã¢', 'â'), 'Ãª', 'ê'), 'Ã´', 'ô'), 'Ã‡', 'Ç'), 'Ãƒ', 'Ã'), 'Ã‰', 'É')
WHERE user_id = (SELECT id FROM auth.users WHERE lower(email)=lower('beeatrisse@gmail.com'))
  AND (description LIKE '%Ã%' OR description LIKE '%â%');
COMMIT;

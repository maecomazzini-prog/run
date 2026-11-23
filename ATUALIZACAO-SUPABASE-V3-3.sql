-- Projeto 10K V3.3: execute uma vez no Supabase SQL Editor.
-- Preserva todos os treinos existentes.
ALTER TABLE public.training_logs ADD COLUMN IF NOT EXISTS continuous_run_km numeric(7,2);
ALTER TABLE public.training_logs DROP CONSTRAINT IF EXISTS training_logs_continuous_run_km_check;
ALTER TABLE public.training_logs ADD CONSTRAINT training_logs_continuous_run_km_check CHECK (continuous_run_km IS NULL OR (continuous_run_km >= 0 AND continuous_run_km <= distance_km AND activity = 'Corrida'));
CREATE TABLE IF NOT EXISTS public.missed_workouts (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
 workout_date date NOT NULL,
 description text,
 created_at timestamptz NOT NULL DEFAULT now(),
 UNIQUE(user_id,workout_date)
);
ALTER TABLE public.missed_workouts ENABLE ROW LEVEL SECURITY;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT,INSERT,UPDATE,DELETE ON public.training_logs TO authenticated;
GRANT SELECT,INSERT,UPDATE,DELETE ON public.missed_workouts TO authenticated;
DROP POLICY IF EXISTS "missed_select_own" ON public.missed_workouts;
DROP POLICY IF EXISTS "missed_insert_own" ON public.missed_workouts;
DROP POLICY IF EXISTS "missed_update_own" ON public.missed_workouts;
DROP POLICY IF EXISTS "missed_delete_own" ON public.missed_workouts;
CREATE POLICY "missed_select_own" ON public.missed_workouts FOR SELECT TO authenticated USING ((select auth.uid())=user_id);
CREATE POLICY "missed_insert_own" ON public.missed_workouts FOR INSERT TO authenticated WITH CHECK ((select auth.uid())=user_id);
CREATE POLICY "missed_update_own" ON public.missed_workouts FOR UPDATE TO authenticated USING ((select auth.uid())=user_id) WITH CHECK ((select auth.uid())=user_id);
CREATE POLICY "missed_delete_own" ON public.missed_workouts FOR DELETE TO authenticated USING ((select auth.uid())=user_id);

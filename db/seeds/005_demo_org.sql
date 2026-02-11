INSERT INTO organizations (id, name, slug, plan) VALUES
  ('00000000-0000-4000-8000-000000000001', 'デモ高校', 'demo-high', 'trial')
ON CONFLICT DO NOTHING;
INSERT INTO schools (id, organization_id, name, prefecture) VALUES
  ('00000000-0000-4000-8000-000000000002', '00000000-0000-4000-8000-000000000001', 'デモ高校', '東京都')
ON CONFLICT DO NOTHING;

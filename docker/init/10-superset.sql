-- cria banco e usuário somente se ainda não existirem
DO
$$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'superset') THEN
      CREATE DATABASE superset;
   END IF;

   IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'superset') THEN
      CREATE USER superset WITH PASSWORD 'supersetpass';
   END IF;

   GRANT ALL PRIVILEGES ON DATABASE superset TO superset;
   GRANT ALL ON SCHEMA public TO superset;
   ALTER SCHEMA public OWNER TO superset;

END;
$$;

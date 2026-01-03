# Proyecto Hola Mundo – React + Supabase

# Propósito
Validar una arquitectura local completa (React + backend serverless + PostgreSQL)
que funcione en local y sea desplegable en producción sin cambios estructurales.

# Backend (Serverless)
- Supabase Edge Functions (Deno, TypeScript)
- Endpoint HTTP que devuelve "Hola Mundo"
- Ejecución local: supabase functions serve
- Despliegue: supabase functions deploy

# Base de datos
- PostgreSQL (Supabase)
- Tabla de ejemplo: mensaje (id, texto)
- Esquema y datos definidos mediante migraciones
- Misma estructura en local y en producción

# Frontend
- React (Vite)
- Consume Edge Functions y consulta la tabla mensaje
- Conexión mediante Supabase JS SDK
- Configuración por variables de entorno (URL y anon key)
- Local: npm start / npm run dev
- Producción: build estático y despliegue en cualquier hosting

# Desarrollo local
- Supabase CLI para servicios locales (DB, Auth, Realtime)
- Edge Functions ejecutadas localmente
- Frontend conectado a Supabase local

# Producción
- Supabase Cloud para DB y Edge Functions
- Hosting externo para el frontend
- Cambio mínimo: solo variables de entorno

# Stack tecnológico
- Frontend: React, TypeScript
- Backend: Supabase Edge Functions (Deno)
- Base de datos: PostgreSQL
- Tooling: Supabase CLI, Supabase JS SDK

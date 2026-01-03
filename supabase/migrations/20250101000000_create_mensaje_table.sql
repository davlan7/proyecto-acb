-- Create mensaje table
CREATE TABLE IF NOT EXISTS mensaje (
    id SERIAL PRIMARY KEY,
    texto TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Insert sample data
INSERT INTO mensaje (texto) VALUES 
    ('Hola Mundo desde PostgreSQL'),
    ('Este es el segundo mensaje'),
    ('Proyecto ACB funcionando correctamente');

import { useEffect, useState } from 'react'
import { supabase } from './supabaseClient'
import './App.css'

interface Mensaje {
  id: number
  texto: string
}

function App() {
  const [holaMundo, setHolaMundo] = useState<string>('')
  const [mensajes, setMensajes] = useState<Mensaje[]>([])
  const [loading, setLoading] = useState<boolean>(true)
  const [error, setError] = useState<string>('')

  useEffect(() => {
    fetchData()
  }, [])

  const fetchData = async () => {
    try {
      setLoading(true)
      setError('')

      // Llamar a la Edge Function
      const { data: functionData, error: functionError } = await supabase.functions.invoke('hola-mundo')
      
      if (functionError) {
        throw new Error(`Error en Edge Function: ${functionError.message}`)
      }

      setHolaMundo(functionData.message || 'No message')

      // Consultar la tabla mensaje
      const { data: mensajesData, error: dbError } = await supabase
        .from('mensaje')
        .select('*')
        .order('id', { ascending: true })

      if (dbError) {
        throw new Error(`Error en base de datos: ${dbError.message}`)
      }

      setMensajes(mensajesData || [])
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Error desconocido')
      console.error('Error fetching data:', err)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="App">
      <h1>Proyecto ACB - Hola Mundo</h1>
      
      {loading && <p>Cargando...</p>}
      
      {error && (
        <div className="error">
          <h3>Error:</h3>
          <p>{error}</p>
        </div>
      )}

      {!loading && !error && (
        <>
          <div className="section">
            <h2>Edge Function Response:</h2>
            <p className="response">{holaMundo}</p>
          </div>

          <div className="section">
            <h2>Mensajes desde PostgreSQL:</h2>
            {mensajes.length === 0 ? (
              <p>No hay mensajes</p>
            ) : (
              <ul>
                {mensajes.map((mensaje) => (
                  <li key={mensaje.id}>
                    <strong>ID {mensaje.id}:</strong> {mensaje.texto}
                  </li>
                ))}
              </ul>
            )}
          </div>

          <button onClick={fetchData}>Recargar datos</button>
        </>
      )}
    </div>
  )
}

export default App

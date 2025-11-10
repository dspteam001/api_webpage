import { useState } from 'react'
import './App.css'
import LLMForm from './components/LLMForm'
import RequestList from './components/RequestList'

function App() {
  const [refreshKey, setRefreshKey] = useState(0)

  const handleRequestComplete = (result) => {
    console.log('Request completed:', result)
    setRefreshKey(prev => prev + 1)
  }

  return (
    <div className="app">
      <header className="app-header">
        <h1>LLM API WebApp</h1>
        <p>다양한 LLM API를 쉽게 테스트하고 관리하세요</p>
      </header>

      <main className="app-main">
        <div className="app-grid">
          <div className="app-section">
            <LLMForm onRequestComplete={handleRequestComplete} />
          </div>

          <div className="app-section">
            <RequestList refresh={refreshKey} />
          </div>
        </div>
      </main>
    </div>
  )
}

export default App

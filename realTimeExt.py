import React, { useState, useEffect } from 'react';
import { initializeApp } from 'firebase/app';
import { getAuth, signInAnonymously, onAuthStateChanged, signInWithCustomToken } from 'firebase/auth';
import { getFirestore, collection, onSnapshot, doc, setDoc, deleteDoc } from 'firebase/firestore';

// IMPORTANT: DO NOT modify __firebase_config, __initial_auth_token, or __app_id.
// These are provided automatically by the Canvas environment.
const firebaseConfig = typeof __firebase_config !== 'undefined' ? JSON.parse(__firebase_config) : {};
const initialAuthToken = typeof __initial_auth_token !== 'undefined' ? __initial_auth_token : null;
const appId = typeof __app_id !== 'undefined' ? __app_id : 'default-app-id';

// API Key for a third-party stock data service.
// You must obtain your own API key from a service like Alpha Vantage, Finnhub, or Polygon.io.
const API_KEY = "YOUR_API_KEY_HERE";
const API_URL = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=";

const formatNumber = (num) => {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(num);
};

const App = () => {
  const [stocks, setStocks] = useState([]);
  const [symbol, setSymbol] = useState('');
  const [userId, setUserId] = useState(null);
  const [isAuthReady, setIsAuthReady] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // Firestore & Auth initialization
  useEffect(() => {
    try {
      if (Object.keys(firebaseConfig).length > 0) {
        const app = initializeApp(firebaseConfig);
        const db = getFirestore(app);
        const auth = getAuth(app);
        
        onAuthStateChanged(auth, async (user) => {
          if (user) {
            setUserId(user.uid);
          } else {
            await signInAnonymously(auth);
          }
          setIsAuthReady(true);
        });

        if (initialAuthToken) {
          signInWithCustomToken(auth, initialAuthToken).catch(err => {
            console.error("Custom auth token sign-in failed:", err);
            signInAnonymously(auth).catch(anonErr => {
              console.error("Anonymous sign-in failed:", anonErr);
            });
          });
        }

        // Expose to window for debugging
        window.db = db;
        window.auth = auth;
      }
    } catch (e) {
      console.error("Firebase initialization failed:", e);
      setIsAuthReady(true);
      setError("Failed to connect to the database. Please check your configuration.");
    }
  }, []);

  // Real-time Firestore listener
  useEffect(() => {
    if (isAuthReady && userId) {
      const db = getFirestore();
      const stocksCollection = collection(db, `artifacts/${appId}/users/${userId}/stocks`);

      const unsubscribe = onSnapshot(stocksCollection, (snapshot) => {
        const stocksData = snapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data(),
          lastUpdated: doc.data().lastUpdated ? doc.data().lastUpdated.toDate() : new Date()
        }));
        // Sort by lastUpdated descending
        stocksData.sort((a, b) => b.lastUpdated - a.lastUpdated);
        setStocks(stocksData);
      }, (err) => {
        console.error("Error fetching stocks:", err);
        setError("Could not retrieve stock data. Please refresh the page.");
      });

      return () => unsubscribe();
    }
  }, [isAuthReady, userId]);

  const fetchAndAddStock = async (e) => {
    e.preventDefault();
    if (!symbol.trim() || !userId) {
      setError("Please enter a stock symbol.");
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const response = await fetch(`${API_URL}${symbol}&apikey=${API_KEY}`);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      
      // LOG THE DATA TO THE CONSOLE
      console.log('API Response Data:', data);

      const quote = data['Global Quote'];
      
      if (!quote || Object.keys(quote).length === 0) {
        throw new Error('Invalid symbol or no data found.');
      }

      const newStock = {
        symbol: quote['01. symbol'],
        open: parseFloat(quote['02. open']),
        high: parseFloat(quote['03. high']),
        low: parseFloat(quote['04. low']),
        price: parseFloat(quote['05. price']),
        volume: parseInt(quote['06. volume'], 10),
        lastTradingDay: quote['07. latest trading day'],
        previousClose: parseFloat(quote['08. previous close']),
        change: parseFloat(quote['09. change']),
        changePercent: parseFloat(quote['10. change percent'].slice(0, -1)),
        lastUpdated: new Date()
      };

      const db = getFirestore();
      const stockRef = doc(db, `artifacts/${appId}/users/${userId}/stocks`, newStock.symbol);
      await setDoc(stockRef, newStock);

      setSymbol('');
    } catch (err) {
      console.error("Error fetching or adding stock:", err);
      setError(`Failed to fetch stock data for ${symbol}. Please check the symbol and your API key.`);
    } finally {
      setLoading(false);
    }
  };

  const deleteStock = async (id) => {
    if (!userId) return;
    const db = getFirestore();
    const docRef = doc(db, `artifacts/${appId}/users/${userId}/stocks`, id);
    try {
      await deleteDoc(docRef);
    } catch (err) {
      console.error("Error deleting stock:", err);
      setError("Failed to delete stock. Please try again.");
    }
  };

  if (error) {
    return (
      <div className="flex items-center justify-center min-h-screen bg-gray-100 p-4">
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg max-w-lg" role="alert">
          <p className="font-bold">Error</p>
          <p>{error}</p>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-gray-900 text-white min-h-screen font-sans flex flex-col items-center p-4">
      <div className="w-full max-w-4xl space-y-8">
        <header className="flex flex-col items-center">
          <h1 className="text-4xl font-extrabold tracking-tight text-transparent bg-clip-text bg-gradient-to-r from-teal-400 to-blue-500 rounded-lg p-2">
            Fintech Tracker
          </h1>
          {userId && (
            <p className="text-sm mt-2 text-gray-400 truncate">
              User ID: <span className="font-mono text-teal-300">{userId}</span>
            </p>
          )}
        </header>

        <section className="bg-gray-800 rounded-2xl shadow-xl p-6">
          <form onSubmit={fetchAndAddStock} className="flex flex-col sm:flex-row items-center gap-4">
            <input
              type="text"
              value={symbol}
              onChange={(e) => setSymbol(e.target.value.toUpperCase())}
              placeholder="Enter stock symbol (e.g., AAPL)"
              className="flex-grow w-full px-4 py-3 bg-gray-700 text-white placeholder-gray-400 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all"
            />
            <button
              type="submit"
              className={`w-full sm:w-auto px-6 py-3 rounded-xl font-bold transition-all transform hover:scale-105 shadow-md
                ${loading ? 'bg-gray-500 cursor-not-allowed' : 'bg-gradient-to-r from-teal-500 to-blue-600 hover:from-teal-600 hover:to-blue-700'}`}
              disabled={loading}
            >
              {loading ? 'Fetching...' : 'Add Stock'}
            </button>
          </form>
        </section>

        {stocks.length > 0 && (
          <section className="bg-gray-800 rounded-2xl shadow-xl p-6">
            <h2 className="text-2xl font-bold mb-4 text-teal-400">My Portfolio</h2>
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {stocks.map(stock => (
                <div key={stock.id} className="bg-gray-700 rounded-xl p-5 shadow-lg flex flex-col justify-between transition-transform transform hover:scale-105">
                  <div className="flex items-center justify-between mb-2">
                    <h3 className="text-xl font-semibold text-blue-300">{stock.symbol}</h3>
                    <span
                      className={`px-3 py-1 rounded-full font-bold text-sm shadow-inner
                        ${stock.changePercent > 0 ? 'bg-green-500 text-green-900' : 'bg-red-500 text-red-900'}`}
                    >
                      {stock.changePercent.toFixed(2)}%
                    </span>
                  </div>
                  <div className="space-y-1 text-gray-300">
                    <p>Price: <span className="font-mono text-white">{formatNumber(stock.price)}</span></p>
                    <p>Open: <span className="font-mono text-white">{formatNumber(stock.open)}</span></p>
                    <p>High: <span className="font-mono text-white">{formatNumber(stock.high)}</span></p>
                    <p>Low: <span className="font-mono text-white">{formatNumber(stock.low)}</span></p>
                    <p>Volume: <span className="font-mono text-white">{stock.volume.toLocaleString()}</span></p>
                  </div>
                  <button
                    onClick={() => deleteStock(stock.id)}
                    className="mt-4 px-4 py-2 rounded-lg font-bold text-sm bg-red-500 text-white hover:bg-red-600 transition-colors self-end"
                  >
                    Remove
                  </button>
                </div>
              ))}
            </div>
          </section>
        )}
      </div>
    </div>
  );
};

export default App;

import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createStackNavigator } from '@react-navigation/stack';
import { NavigationContainer } from '@react-navigation/native';
import Home from './components/Home';
import PokemonList from './components/PokemonList';
import Favourites from './components/Favourites';
import Settings from './components/Settings';
import { Icon } from '@rneui/themed';
import { StyleSheet, View } from 'react-native';
import PokemonData from './components/PokemonData';

import ReactNativeAsyncStorage from '@react-native-async-storage/async-storage';

import { initializeApp } from 'firebase/app'
import { getDatabase } from 'firebase/database'
import { initializeAuth, createUserWithEmailAndPassword, signInWithEmailAndPassword, signOut, getReactNativePersistence } from 'firebase/auth'

import { API_KEY, AUTH_DOMAIN, DB_URL, PROJECT_ID, STORAGE_BUCKET, MSG_SENDER_ID, APP_ID, MEASUREMENT_ID } from '@env';

const Tab = createBottomTabNavigator();
const Stack = createStackNavigator();

const firebaseConfig = {
  apiKey: API_KEY,
  authDomain: AUTH_DOMAIN,
  databaseURL: DB_URL,
  projectId: PROJECT_ID,
  storageBucket: STORAGE_BUCKET,
  messagingSenderId: MSG_SENDER_ID,
  appId: APP_ID,
  measurementId: MEASUREMENT_ID,
};

const app = initializeApp(firebaseConfig);
export const database = getDatabase(app);
export const auth = initializeAuth(app, {
  persistence: getReactNativePersistence(ReactNativeAsyncStorage)
});

export const registerWithEmailAndPassword = (email, password) => {
  return createUserWithEmailAndPassword(auth, email, password)
    .then((userCredential) => {
      const user = userCredential.user;
    })
    .catch((error) => {
      const errorCode = error.code;
      const errorMessage = error.message;
      console.log(errorCode + " " + errorMessage)
    });
};

export const signIn = (email, password) => {
  return signInWithEmailAndPassword(auth, email, password)
    .then((userCredential) => {
      const user = userCredential.user;
    })
    .catch((error) => {
      const errorCode = error.code;
      const errorMessage = error.message;
      console.log(errorCode + " " + errorMessage)
    });
};

export const signOutOfAccount = (auth) => {
  if (auth) {
    return signOut(auth)
      .then(() => {
        alert("User signed out successfully")
      })
      .catch((error) => {
        const errorCode = error.code;
        const errorMessage = error.message;
        console.log(errorCode + " " + errorMessage)
      });
  } else {
    console.log("Auth is undefined");
  }
};


export default function App() {
  return (
    <NavigationContainer>
      <Tab.Navigator screenOptions={{
        tabBarActiveTintColor: 'green'
      }}>
        <Tab.Screen
          name="Home"
          component={Home}
          options={{
            tabBarIcon: ({ color }) => (
              <Icon name="home" color={color} />
            )
          }}
        />
        <Tab.Screen name='Pokemon List' options={{
          tabBarIcon: ({ color }) => (
            <Icon name='list' color={color} />
          )
        }}>
          {() => (
            <Stack.Navigator initialRouteName='List'>
              <Stack.Screen name="Pokemon Data" component={PokemonData} />
              <Stack.Screen name="List" component={PokemonList} options={{ headerShown: false }} />
            </Stack.Navigator>
          )}
        </Tab.Screen>
        <Tab.Screen name='Favourites' options={{
          tabBarIcon: ({ color }) => (
            <Icon name='star' color={color} />
          )
        }}>
          {() => (
            <Stack.Navigator initialRouteName='Favs'>
              <Stack.Screen name="Pokemon Data" component={PokemonData} />
              <Stack.Screen name="Favs" component={Favourites} options={{ headerShown: false }} />
            </Stack.Navigator>
          )}
        </Tab.Screen>
        <Tab.Screen
          name='Settings'
          component={Settings}
          options={{
            tabBarIcon: ({ color }) => (
              <Icon name='settings' color={color} />
            )
          }}
        />
      </Tab.Navigator>
    </NavigationContainer>
  );
}

const styles = StyleSheet.create({
  navOptions: {
    flex: 1,
    backgroundColor: '#90EE90',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20
  },
});
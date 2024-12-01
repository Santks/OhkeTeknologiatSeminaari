import { StyleSheet, Text, View, ActivityIndicator, FlatList, Button, TouchableOpacity, TextInput } from 'react-native';
import { useEffect, useState } from 'react';
import { useNavigation } from '@react-navigation/native';
import { Icon, ListItem, Input } from '@rneui/themed';
import { auth, database } from '../App';
import { push, ref } from 'firebase/database';

export default function PokemonList() {

    const navigation = useNavigation();

    const [pokemon, setPokemon] = useState([]);
    const [loading, setLoading] = useState(false);
    const [keyword, setKeyword] = useState("")

    let nextId = 1;

    const generateId = () => {
        const uniqueId = nextId.toString();
        nextId++
        return uniqueId;
    }

    const fetchPkmn = () => {
        setLoading(true)
        fetch('https://pokeapi.co/api/v2/pokemon/?limit=1302')
            .then(response => {
                if (!response)
                    throw new Error("Error when trying to fetch data " + response.statusText)
                return response.json()
            })
            .then(data => {
                const modifiedData = data.results.map((item, index) => {
                    const pkmnId = generateId();
                    return { ...item, pkmnId };
                });
                setPokemon(modifiedData)
                setLoading(false)
            })
            .catch(err => {
                console.error(err)
                setLoading(false)
            })
    };

    useEffect(() => {
        fetchPkmn();
    }, []);

    const textFormat = (str) => {
        return str.charAt(0).toUpperCase() + str.slice(1);
    };

    const filtered = pokemon.filter(item =>
        item.name.toLowerCase().includes(keyword.toLowerCase())
    );

    const addFavourite = (item) => {
        const user = auth.currentUser;
        if (user === null) {
            alert("Log in to add favourites!")
        } else {
            const userRef = ref(database, `users/${user.uid}`);
            push(userRef, item);
            alert(`${textFormat(item.name)} added to favourites!`)
        }
    };

    renderItem = ({ item }) => (
        <ListItem bottomDivider>
            <ListItem.Content style={styles.list} >
                <ListItem.Title style={{ fontSize: 25 }}>{textFormat(item.name)}</ListItem.Title>
                <Icon
                    name='info'
                    onPress={() => navigation.navigate('Pokemon Data', { pokemon: item })}
                    color={'white'}
                    size={30}
                />
                <Icon
                    name='star'
                    onPress={() => addFavourite(item)}
                    color={'yellow'}
                    size={31}
                />
            </ListItem.Content>
        </ListItem>)

    if (loading) {
        return (
            <View style={styles.container}>
                <ActivityIndicator size={'large'} />
            </View>
        )
    } else {
        return (
            <View style={styles.container}>
                <FlatList
                    keyExtractor={item => item.pkmnId}
                    renderItem={renderItem}
                    data={keyword === "" ? pokemon : filtered}
                    pagingEnabled={true}
                    disableVirtualization={false}
                    ListHeaderComponent={
                        <TextInput
                            style={{ height: 40, borderColor: 'gray', borderWidth: 1, margin: 10, paddingHorizontal: 10, backgroundColor: '#fff' }}
                            placeholder='Search...'
                            onChangeText={text => setKeyword(text)}
                            value={keyword}
                        />}
                />
            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#90EE90',
    },
    list: {
        flexDirection: 'row',
        backgroundColor: '#90EE90',
        alignItems: 'center',
        justifyContent: 'space-evenly',
        padding: 14,
        borderRadius: 12
    },
});
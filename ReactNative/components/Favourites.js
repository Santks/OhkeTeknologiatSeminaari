import { StyleSheet, Text, View, FlatList, ActivityIndicator, TouchableOpacity, Button, Alert } from 'react-native';
import { useEffect, useState } from 'react';
import { useNavigation } from '@react-navigation/native';
import { Icon, ListItem } from '@rneui/themed';
import { database, auth } from '../App';
import { ref, onValue, remove } from 'firebase/database';

export default function Favourites() {

    const navigation = useNavigation();

    const [loading, setLoading] = useState(false);
    const [favourites, setFavourites] = useState([]);

    useEffect(() => {
        setLoading(true);

        const unsubscribeAuth = auth.onAuthStateChanged(user => {
            if (user) {
                const userRef = ref(database, `users/${user.uid}`);
                onValue(userRef, (snapshot) => {
                    const data = snapshot.val();
                    if (data) {
                        const keys = Object.keys(data);
                        const favsArray = keys.map((key) => ({ ...data[key], id: key }));
                        setFavourites(favsArray);
                        setLoading(false);
                    }
                });
            } else {
                setFavourites([]);
                setLoading(false);
            }
        });

        return () => unsubscribeAuth();
    }, []);

    const deleteFavourite = (itemId) => {
        const user = auth.currentUser
        Alert.alert(
            'Delete Confirmation',
            'Are you sure you want to delete this favourite?',
            [
                {
                    text: 'Cancel',
                    style: 'cancel',
                },
                {
                    text: 'Delete',
                    onPress: () => {
                        remove(ref(database, `users/${user.uid}/${itemId}`));
                        alert("Favourite removed.");
                    },
                    style: 'destructive',
                },
            ],
            { cancelable: true }
        );
    };

    const textFormat = (str) => {
        return str.charAt(0).toUpperCase() + str.slice(1);
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
                    name='delete'
                    onPress={() => deleteFavourite(item.id)}
                    color={'red'}
                    size={30}
                />
            </ListItem.Content>
        </ListItem>)

    if (loading) {
        return (
            <View style={styles.container}>
                <ActivityIndicator size={'large'} />
            </View>
        )
    } else if (!favourites || favourites.length === 0) {
        return (
            <View style={styles.empty}>
                <Text>No favourites added yet!</Text>
            </View>
        )
    } else {
        return (
            <View style={styles.container}>
                <FlatList
                    keyExtractor={item => item.pkmnId}
                    renderItem={renderItem}
                    data={favourites}
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
    empty: {
        flex: 1,
        backgroundColor: '#90EE90',
        alignItems: 'center',
        justifyContent: 'center'
    }
});
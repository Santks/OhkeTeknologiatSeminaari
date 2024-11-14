import { StyleSheet, Text, View, Button } from 'react-native';
import { signOutOfAccount, auth } from '../App';
import { useNavigation } from '@react-navigation/native';


export default function Settings() {

    const navigation = useNavigation();

    const handleLogout = async (auth) => {
        try {
            const user = auth.currentUser
            if (user) {
                await signOutOfAccount(auth)
                navigation.navigate("Home")
            } else {
                alert("Not logged in to any user!")
            }
        } catch (error) {
            console.log("Error happened while trying to logout" + error.code + error.message)
        }
    }

    return (
        <View style={styles.container}>
            <Text>Page to edit settings and log out</Text>
            <Button
                title='logout'
                onPress={() => handleLogout(auth)}
            />
        </View>
    )
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#90EE90',
        alignItems: 'center',
        justifyContent: 'center',
    },
});
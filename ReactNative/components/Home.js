import { StyleSheet, Text, View, Button } from 'react-native';
import { useState } from 'react'
import Dialog from 'react-native-dialog'
import { auth, registerWithEmailAndPassword, signIn } from '../App';

export default function Home() {

    const [visibleLogin, setVisibleLogin] = useState(false);
    const [visibleRegister, setVisibleRegister] = useState(false)
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");

    const showLoginDialog = () => {
        setVisibleLogin(true);
    };

    const showRegisterDialog = () => {
        setVisibleRegister(true);
    }

    const handleClose = () => {
        setVisibleLogin(false);
        setVisibleRegister(false)
        setEmail("");
        setPassword("");
    };

    const handleRegister = async (email, password) => {
        try {
            await registerWithEmailAndPassword(email, password)
            alert("Account created!");
            handleClose();
        } catch (error) {
            alert("Error while trying to register: ");
            console.log("Error while trying to register" + error.code + error.message)
        }
    };

    const handleLogin = async (email, password) => {
        try {
            await signIn(email, password);
            alert("Logged in to account " + email);
            handleClose();
        } catch (error) {
            console.log("Error happened during login" + error.code + error.message);
        }
    };

    return (
        <View style={styles.container}>
            <Text>Welcome to the pokemon info mobile app!</Text>
            <Button
                title='Log in'
                onPress={showLoginDialog}
            />
            <Dialog.Container visible={visibleLogin} onBackdropPress={handleClose} style={styles.dialog}>
                <Dialog.Title>Sign in</Dialog.Title>
                <Dialog.Input placeholder="Email..." onChangeText={text => setEmail(text)} />
                <Dialog.Input placeholder="Password..." onChangeText={text => setPassword(text)} secureTextEntry={true} />
                <Dialog.Button label="Cancel" onPress={handleClose} />
                <Dialog.Button label="Sign in" onPress={() => handleLogin(email, password)} />
            </Dialog.Container>
            <Text>Don't have an account? Register here to add favourite pokemon!</Text>
            <Button
                title='Sign up'
                onPress={showRegisterDialog}
            />
            <Dialog.Container visible={visibleRegister} onBackdropPress={handleClose} style={styles.dialog}>
                <Dialog.Title>Create account</Dialog.Title>
                <Dialog.Input placeholder="Email..." onChangeText={text => setEmail(text)} />
                <Dialog.Input placeholder="Password..." onChangeText={text => setPassword(text)} secureTextEntry={true} />
                <Dialog.Button label="Cancel" onPress={handleClose} />
                <Dialog.Button label="Sign up" onPress={() => handleRegister(email, password)} />
            </Dialog.Container>
        </View>
    )
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#90EE90',
        alignItems: 'center',
        justifyContent: 'center',
        padding: 10,
    },
    dialog: {
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#90EE90'
    },
});
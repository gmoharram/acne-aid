import React, { useState } from 'react';
import { StyleSheet, Image } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { MaterialCommunityIcons } from '@expo/vector-icons';

import ParallaxScrollView from '@/components/ParallaxScrollView';

// Themed components
import { ThemedView } from '@/components/Themed/ThemedView';
import { ThemedText } from '@/components/Themed/ThemedText';
import { ThemedTextInput } from '@/components/Themed/ThemedTextInput';
import { ThemedButton } from '@/components/Themed/ThemedButton';

// Custom components
import { HelloWave } from '@/components/HelloWave';

export default function SignInScreen() {
    const navigation = useNavigation();
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [showPassword, setShowPassword] = useState(false);

    return (
        <ParallaxScrollView
            headerBackgroundColor={{ light: '#A1CEDC', dark: '#1D3D47' }}
            headerImage={
                <Image
                    source={require('@/assets/images/partial-react-logo.png')}
                    style={styles.reactLogo}
                />
            }>
            <ThemedView style={styles.mainContainer}>
                <ThemedView style={styles.titleContainer}>
                    <ThemedText type="title">Welcome Back!</ThemedText>
                    <HelloWave />
                </ThemedView>

                <ThemedView style={styles.inputContainer}>
                    <ThemedText style={styles.label} >Email</ThemedText>
                    <ThemedTextInput
                        style={styles.input}
                        placeholder="Enter email..."
                        value={email}
                        onChangeText={setEmail}
                    />
                </ThemedView>

                <ThemedView style={styles.inputContainer}>
                    <ThemedText style={styles.label} >Password</ThemedText>
                    <ThemedTextInput
                        style={styles.input}
                        placeholder="Enter password..."
                        secureTextEntry={!showPassword}
                        value={password}
                        onChangeText={setPassword}
                    />
                </ThemedView>

                <ThemedView style={styles.forgotPassword}>
                    <ThemedText type="default">Forgot password?</ThemedText>
                </ThemedView>

                <ThemedView style={styles.signInButton}>
                    <ThemedButton
                        title="Sign In"
                        onPress={() => navigation.navigate('(tabs)')}
                        type="primary"
                    />
                </ThemedView>

                <ThemedView style={styles.signUp}>
                    <ThemedText type="default">Don't have an account yet?</ThemedText>
                    <ThemedText type="link" onPress={() => navigation.navigate('(auth)/signup')}> Sign Up</ThemedText>
                </ThemedView>
            </ThemedView>
        </ParallaxScrollView >
    );
}

const styles = StyleSheet.create({
    reactLogo: {
        height: 178,
        width: 290,
        bottom: 0,
        left: 0,
        position: 'absolute',
    },
    mainContainer: {
        padding: 20,
        alignSelf: 'center',
        width: '90%',
    },
    titleContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        alignSelf: 'center',
        paddingBottom: 40,
        gap: 8,
    },
    inputContainer: {
        marginBottom: 10,
    },
    label: {
        fontSize: 16,
        fontWeight: 'bold',
        marginBottom: 5,
    },
    input: {
        height: 40,
        paddingLeft: 10,
    },
    forgotPassword: {
        alignItems: 'flex-end',
    },
    signInButton: {
        paddingVertical: 15,
    },
    signUp: {
        alignSelf: 'center',
        alignItems: 'center',
        marginTop: 10,
        flexDirection: 'row',
    },
});
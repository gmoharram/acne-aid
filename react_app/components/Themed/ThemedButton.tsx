import { Pressable, type PressableProps, Text, StyleSheet } from 'react-native';

import { useThemeColor } from '@/hooks/useThemeColor';

export type ThemedButtonProps = PressableProps & {
    title: string;
    lightBackgroundColor?: string;
    darkBackgroundColor?: string;
    lightTextColor?: string;
    darkTextColor?: string;
    type?: 'primary' | 'secondary';
};

export function ThemedButton({
    title,
    onPress,
    lightBackgroundColor,
    darkBackgroundColor,
    lightTextColor,
    darkTextColor,
    type = 'primary',
    ...rest
}: ThemedButtonProps) {
    const backgroundColor = useThemeColor(
        { light: lightBackgroundColor, dark: darkBackgroundColor },
        type === 'primary' ? 'primaryButtonBackground' : 'secondaryButtonBackground',
    );
    const color = useThemeColor(
        { light: lightTextColor, dark: darkTextColor },
        type === 'primary' ? 'primaryButtonText' : 'secondaryButtonText',
    );

    return (
        <Pressable
            style={[
                styles.button,
                { backgroundColor },
            ]}
            onPress={onPress}
            {...rest}>
            <Text style={[styles.text, { color }]}>{title}</Text>
        </Pressable>
    );


}

const styles = StyleSheet.create({
    button: {
        alignItems: 'center',
        justifyContent: 'center',
        paddingVertical: 12,
        paddingHorizontal: 32,
        borderRadius: 15,
        elevation: 3,
    },
    text: {
        fontSize: 16,
        lineHeight: 21,
        fontWeight: 'bold',
        letterSpacing: 0.25,
    },
});
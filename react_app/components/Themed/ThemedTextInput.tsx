import { TextInput, type TextInputProps, StyleSheet } from 'react-native';

import { useThemeColor } from '@/hooks/useThemeColor';

export type ThemedTextInputProps = TextInputProps & {
  lightColor?: string;
  darkColor?: string;
};

export function ThemedTextInput({
  style,
  lightColor,
  darkColor,
  ...rest
}: ThemedTextInputProps) {
  const color = useThemeColor({ light: lightColor, dark: darkColor }, 'text');
  const placeholderTextColor = useThemeColor({ light: lightColor, dark: darkColor }, 'textInputPlaceholder');
  const backgroundColor = useThemeColor({ light: lightColor, dark: darkColor }, 'textInputBackground');
  const borderWidth = 0;
  const borderRadius = 15;

  return (
    <TextInput
      style={[
        { color, backgroundColor, borderWidth, borderRadius },
        style,
      ]}
      placeholderTextColor={placeholderTextColor}
      {...rest}
    />
  );
}
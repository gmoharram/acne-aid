/**
 * Below are the colors that are used in the app. The colors are defined in the light and dark mode.
 * There are many other ways to style your app. For example, [Nativewind](https://www.nativewind.dev/), [Tamagui](https://tamagui.dev/), [unistyles](https://reactnativeunistyles.vercel.app), etc.
 */

const tintColorLight = '#0a7ea4';
const tintColorDark = '#fff';

export const Colors = {
  light: {
    text: '#11181C',
    background: '#fff',
    tint: tintColorLight,
    icon: '#687076',
    tabIconDefault: '#687076',
    tabIconSelected: tintColorLight,
    textInputBackground: '#F3F4F6',
    textInputPlaceholder: '#BDC1CA',
    primaryButtonBackground: '#0a7ea4',
    primaryButtonText: '#ffffff',
    secondaryButtonBackground: '#f5f5f5',
    secondaryButtonText: '#11181C',
  },
  dark: {
    text: '#ECEDEE',
    background: '#151718',
    tint: tintColorDark,
    icon: '#9BA1A6',
    tabIconDefault: '#9BA1A6',
    tabIconSelected: tintColorDark,
    textInputBackground: '#1D1E21',
    textInputPlaceholder: '#9BA1A6',
    primaryButtonBackground: '#0a7ea',
    primaryButtonText: '#ffffff',
    secondaryButtonBackground: '#1D1E21',
    secondaryButtonText: '#ECEDEE',
  },
};

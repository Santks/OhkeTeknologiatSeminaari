import { StyleSheet, Text, View, ActivityIndicator, FlatList, Image, Dimensions } from 'react-native';
import { useEffect, useState } from 'react';
import { BackHandler } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { BarChart } from 'react-native-chart-kit';

const typeColor = (type) => {
    switch (type) {
        case 'bug':
            return '#91A119';
        case 'dark':
            return '#624D4E';
        case 'dragon':
            return '#5060E1';
        case 'electric':
            return '#FAC000';
        case 'fairy':
            return '#EF70EF';
        case 'fighting':
            return '#A65300';
        case 'fire':
            return '#E62829';
        case 'flying':
            return '#81B9EF';
        case 'ghost':
            return '#704170';
        case 'grass':
            return '#3FA129';
        case 'ground':
            return '#915121';
        case 'ice':
            return '#3DCEF3';
        case 'normal':
            return '#9FA19F';
        case 'poison':
            return '#9141CB';
        case 'psychic':
            return '#EF4179';
        case 'rock':
            return '#AFA981';
        case 'steel':
            return '#60A1B8';
        case 'water':
            return '#2980EF';
        default:
            return '#FFFFFF';
    }
};

export default function PokemonData({ route }) {

    const navigation = useNavigation();

    const { pokemon } = route.params
    const [pokemonData, setPokemonData] = useState([]);
    const [loading, setLoading] = useState(false);

    const imageUrl = `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.pkmnId}.png`

    const fetchInfo = () => {
        setLoading(true)
        fetch(`https://pokeapi.co/api/v2/pokemon/${pokemon.name}`)
            .then(response => {
                if (!response)
                    throw new Error("Error when trying to get pokemon data" + response.statusText)
                return response.json();
            })
            .then(data => {
                setPokemonData(data)
                setLoading(false)
            })
            .catch(err => {
                console.error(err)
            })
    };

    const textFormat = (str) => {
        const formattedName = str.charAt(0).toUpperCase() + str.slice(1);
        return formattedName;
    };

    const screenWidth = Dimensions.get("window").width;

    const chartData = {
        labels: ["HP", "Attack", "Defense", "Sp. Atk", "Sp. Def", "Speed"],
        datasets: [{
            data: [],
        },
        ]
    };

    if (pokemonData.stats && pokemonData.stats.length > 0) {
        pokemonData.stats.forEach(stat => {
            chartData.datasets[0].data.push(stat.base_stat);
        });
    }

    const chartConfig = {
        backgroundGradientFrom: '#F0F0F0',
        backgroundGradientTo: '#F0F0F0',
        decimalPlaces: 0,
        color: (opacity = 100) => `rgba(46, 139, 87, ${opacity})`,
        labelColor: (opacity = 1) => `rgba(0, 0, 0, ${opacity})`,
    };

    useEffect(() => {
        const backAction = () => {
            navigation.navigate('Pokemon List', { screen: 'List' })
            return true;
        };
        const backHandler = BackHandler.addEventListener('hardwareBackPress', backAction);
        return () => backHandler.remove();
    }, []);

    useEffect(() => {
        fetchInfo()
    }, []);

    if (loading) {
        return (
            <View style={styles.container}>
                <ActivityIndicator size={'large'} />
            </View>
        );
    } else {
        return (
            <View style={styles.container}>
                <Image
                    style={{ width: 125, height: 125, borderColor: "gray", borderWidth: 2, borderRadius: 10, backgroundColor: '#fff' }}
                    source={{ uri: imageUrl }}
                />
                <Text style={{ fontSize: 20 }}>
                    {textFormat(pokemon.name)}
                </Text>
                <Text>
                    Weight: {pokemonData.weight / 10} kg, Height: {pokemonData.height / 10} m
                </Text>
                <FlatList
                    data={pokemonData.types}
                    horizontal={true}
                    keyExtractor={(item, index) => index.toString()}
                    renderItem={({ item }) => (
                        <View style={styles.type(item.type.name)}>
                            <Text style={styles.text}>{textFormat(item.type.name)}</Text>
                        </View>
                    )}
                />
                <Text style={{ marginTop: 5 }}>Stats:</Text>
                <BarChart
                    data={chartData}
                    width={screenWidth - 10}
                    height={250}
                    yAxisLabel=""
                    showValuesOnTopOfBars={true}
                    chartConfig={chartConfig}
                    fromZero={true}
                    fromNumber={255}
                    segments={5}
                    style={{
                        borderColor: 'grey', borderRadius: 10, alignSelf: 'center',
                    }}
                />
                <FlatList
                    data={pokemonData.abilities}
                    keyExtractor={(item, index) => index.toString()}
                    renderItem={({ item }) => (
                        <View style={styles.list}>
                            <Text>
                                {item.is_hidden
                                    ? textFormat(item.ability.name) + " (Hidden ability)"
                                    : textFormat(item.ability.name)}
                            </Text>
                        </View>
                    )}
                    ListHeaderComponent={
                        <Text style={{ textAlign: 'center', marginTop: 10 }}>Abilities:</Text>
                    }
                />
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#90EE90',
        alignItems: 'center',
        justifyContent: 'center',
    },
    list: {
        flexDirection: 'row',
        backgroundColor: '#90EE90',
        alignItems: 'center',
        justifyContent: 'center',
        marginVertical: 10,
        marginBottom: 0
    },
    type: (type) => ({
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        padding: 8,
        borderWidth: 1,
        borderRadius: 12,
        marginTop: 5,
        width: 80,
        alignSelf: 'flex-start',
        marginLeft: 5,
        marginRight: 5,
        backgroundColor: typeColor(type)
    }),
    text: {
        color: 'white',
        textAlignVertical: 'top',
    }
});
<template>
  <v-app class="restaurantes">
    <v-layout text-center>
      <v-card width="100%">
        <!-- ~~~~~~~~~~~~~~~~~ BAR ~~~~~~~~~~~~~~~~ -->
        <v-card id="search" flat color="transparent">
          <v-toolbar style="font-size:1vw; margin: auto; margin-top:2%;" id="toolbar" height="60%" max-width="75%"
            elevation="10">
            <v-text-field type="text" v-model="search" class="capitalised" solo flat color="yellow" hide-details
              append-icon="mdi-magnify" placeholder="Pesquisa" single-line></v-text-field>
            <v-divider vertical inset class="mx-5"></v-divider>
            <v-overflow-btn :items="organize" item-text="name" hide-details label="Organizar"
              v-model="organizedRestaurants" flat solo color="yellow lighten-3"></v-overflow-btn>
            <v-divider vertical inset class="mx-5"></v-divider>
            <v-text-field color="yellow" hide-details solo flat append-icon="mdi-map-marker" placeholder="Localização"
              single-line></v-text-field>
          </v-toolbar>
        </v-card>
        <v-row>
          <!-- ~~~~~~~~~~~~~~~~~ FILTROS ~~~~~~~~~~~~~~~~ -->
          <v-col style="max-width: 25%; min-width: 25%; font-family:lato;">
            <div style="background-color: #F9FAFB; height:3530px; margin-bottom: 0px">
              <br />
              <br />
              <v-card-text class="text-left"
                style="font-weight: 700; font-family:lato; margin-left: 48%; font-size: 18px;">Filtros</v-card-text>
              <v-treeview v-model="tagged" selection-type="selectionType"
                style="min-width: 25% font-weight: 300; font-size: 13px; margin-left: 43%" class="text-left" rounded
                selectable selected-color="yellow" :items="items" return-object></v-treeview>
            </div>
          </v-col>
          <!-- ~~~~~~~~~~~~~~~~~ GRID ~~~~~~~~~~~~~~~~ -->
          <!-- Cards restaurantes -->
          <v-col style="max-width: 65%; min-width:65%, padding-bottom: 0px">
            <v-layout row wrap class="ma-6">
              <v-flex xs12 sm6 md4 lg4 v-for="restaurant in sortedRestaurants" :key="restaurant.id">
                <v-card class="mx-auto ma-6" min-width="350" max-width="350">
                  <v-img height="250" v-bind:src=restaurant.photo></v-img>

                  <v-card-title
                    style="font-family:lato; font-weight: 500; font-size: 18px; margin-left: 3%; padding-bottom: 0;">
                    {{ restaurant.name }}</v-card-title>

                  <v-row style="font-family:lato; font-weight: 500; font-size: 12px; color: hsla(0, 0%, 0%, 0.4)"
                    class="mx-0">
                    <v-rating v-model="restaurant.rating" background-color="yellow accent-4" color="yellow accent-4"
                      style="margin-left: 6%" dense half-increments readonly size="18">
                    </v-rating>({{ restaurant.rating }})
                  </v-row>

                  <v-row style="font-family:lato; font-weight: 500; font-size: 12px; color: hsla(0, 0%, 0%, 0.4)"
                    class="mx-0">
                    <div style="margin-left: 7%">
                      <v-icon x-small>mdi-map-marker</v-icon>
                      {{ restaurant.address }}
                    </div>
                    <div style="margin-left: 16%">
                      <v-icon x-small>mdi-phone hangup</v-icon>
                      {{ restaurant.contacts }}
                    </div>
                  </v-row>

                  <v-card-text style="font-family:lato; margin-top; min-height: 130px">
                    <div style="font-weight: 300; text-align: left; margin-left: 4%; margin-bottom: 8%">
                      {{ restaurant.tags }}
                    </div>

                    <div style="font-weight: 500; margin-left:3%; height: 80px" class="text-left">
                      {{ restaurant.desc }}
                    </div>
                  </v-card-text>

                  <v-divider class="mx-4"></v-divider>

                  <v-card-actions>
                    <router-link to="/reservas">
                      <v-btn style="margin-left: 100%" color="black" outlined text @click="reserve">Reservar</v-btn>
                    </router-link>
                  </v-card-actions>
                </v-card>
              </v-flex>
            </v-layout>
          </v-col>
        </v-row>
      </v-card>
    </v-layout>
  </v-app>
</template>

<script>
  export default {
    name: "Restaurantes",
    data() {
      return {
        selectionType: "leaf",
        search: "",
        tagged: "",
        organizedRestaurants: "",
        items: [{
            id: 1,
            name: "Todos"
          },
          {
            id: 2,
            name: "Fast Food"
          },
          {
            id: 3,
            name: "Vegetariano"
          },
          {
            id: 4,
            name: "Vegan"
          },
          {
            id: 5,
            name: "Saudável"
          },
          {
            id: 6,
            name: "Tradicional"
          },
          {
            id: 7,
            name: "Peixe"
          },
          {
            id: 8,
            name: "Carne"
          },
          {
            id: 9,
            name: "Indiano"
          },
          {
            id: 10,
            name: "Japonês"
          },
          {
            id: 11,
            name: "Sobremesas"
          },
          {
            id: 12,
            name: "Esplanada"
          },
          {
            id: 13,
            name: "Mediterrâneo"
          },
          {
            id: 14,
            name: "Informal"
          },
          {
            id: 15,
            name: "Vinhos"
          },
          {
            id: 16,
            name: "Cervejaria"
          }
        ],

        restaurants: this.$store.getters.getRestaurants,

        organize: [{
            name: "A-Z",           
          },
          {
            name: "Rating",
            function: ""
          },
          {
            name: "Mais Próximos",
            function: ""
          }
        ]
      };
    },
    created() {
      this.getCurrentLocation();
    },
    beforeMount() {
      this.calcDistance();
    },
    computed: {
      sortedRestaurants() {
      if (this.organizedRestaurants == "Rating") {
        this.$store.getters.getRestaurantsByRating;
      } else if (this.organizedRestaurants == "A-Z") {
        this.$store.getters.getRestaurantByAlphOrder;
      }else if (this.organizedRestaurants == "Mais Próximos"){
        this.$store.getters.getRestaurantsByDistance;
      } else {
        this.$store.getters.getRestaurantsById;
      }

      if (this.search != "") {
        return this.restaurants.filter(restaurant => {
          return restaurant.name
            .toLowerCase()
            .includes(this.search.toLowerCase());
        });
      } else {
        return this.restaurants;
      }
    }
  },
   methods: {
      ola() {
        alert(this.tagged);
      },
      getCurrentLocation() {
      if (navigator.geolocation) {
        navigator.geolocation.watchPosition(position => {
          const myPos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude
          };
          this.$store.commit("ADD_CURRENT_LOCATION", {
            location: myPos
          });          
        },
         error=> {
            alert(error.message)
          }
        );
      } else {
        alert("error badjoras");
      }
    },
    },  
    
  };
</script>
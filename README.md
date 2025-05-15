# Ualá Challenge

Este proyecto fue desarrollado como solución al challenge técnico propuesto por Ualá.  
La aplicación permite visualizar, buscar y marcar como favoritas ciudades de un dataset global.

---

## 🏛️ Arquitectura y Enfoque

El proyecto sigue una arquitectura **MVVM + Repository Pattern**, para garantizar:
- Separación de responsabilidades
- Testabilidad
- Escalabilidad

### Capas principales:
- **Model:** `City`
- **ViewModel:** `CitiesListViewModel`
- **View:** `CitiesListView`
- **Repository:** `CitiesRepository` + `RemoteCitiesRepository`
- **Persistence:** `FavouritesStore` + `UserDefaultsFavouritesStore`

---

## 🔍 Search Algorithm (Solución al problema)

Para resolver el problema de búsqueda eficiente sobre más de 200.000 ciudades, se implementó un **Trie Data Structure** (`CityTrie`).

### Por qué un Trie:
El Trie permite realizar **búsquedas por prefijo** de forma muy rápida (O(m)), donde m es la longitud del prefijo buscado.  
Esto evita recorrer todo el array completo de ciudades.

### Funcionamiento:
- Al cargar los datos, cada ciudad se inserta en el Trie por su nombre (`city.name`).
- Cuando el usuario escribe en la barra de búsqueda (`searchText`), se hace una búsqueda por prefijo en el Trie.
- Los resultados coincidentes se filtran además según si el toggle "showFavoritesOnly" está activo.

Este enfoque logra una experiencia de usuario **fluida y sin lag** incluso en datasets muy grandes.

---

## 💾 Persistencia de Favoritos

Para cumplir con el requerimiento **"Favourite cities should be remembered between app launches"**:
- Se almacena un `Set<Int>` con los IDs de las ciudades favoritas en `UserDefaults` (`UserDefaultsFavouritesStore`).
- Al volver a iniciar la app, los favoritos se aplican a la lista completa de ciudades.

---

## 🛠️ Decisiones Técnicas Importantes

### Debounce
Para evitar recalcular filtros en cada key stroke, se aplicó un **debounce de 300ms** con `DispatchWorkItem`.  
Esto asegura máxima responsividad sin sacrificar performance.

### Pagination
Se aplicó **lazy pagination** al mostrar las ciudades para mejorar la performance inicial:
- Se cargan 100 ciudades por página.
- Al llegar al final de la lista, se cargan 100 más (`loadMoreIfNeeded`).

### Repository Pattern
Para desacoplar el origen de datos:
- En producción: `RemoteCitiesRepository`
- Para testing: `MockCitiesRepository`

Esto permitió también realizar tests unitarios de forma aislada (`CitiesListViewModelTests`).

---

## ✅ Asunciones

1. El dataset de ciudades se obtiene una única vez al inicio.
2. El botón "info" de cada ciudad muestra un detalle básico del dataset (nombre, país, coordenadas).
3. La persistencia local de favoritos es suficiente para este challenge.

---

## ✅ Test Coverage

Se implementaron **tests unitarios usando Swift Testing** para validar:
- El algoritmo de búsqueda para diferentes casos (coincidencias, no coincidencias, string vacío).
- La performance y correcto funcionamiento del filtrado.

---

## 📝 Conclusión

La solución implementada cumple con todos los puntos solicitados:
- UI fluida y responsive
- Búsqueda eficiente para grandes datasets
- Persistencia de favoritos
- Tests unitarios
- Uso de arquitectura limpia y patrones de diseño recomendados (MVVM + Repository Pattern)


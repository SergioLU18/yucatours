import 'package:latlong2/latlong.dart';
import '../models/tour.dart';

class StaticData {
  static final List<Tour> tours = [
    // ─────────────────────────────────────────────────────
    // TOUR 1 – CHICHEN ITZA
    // ─────────────────────────────────────────────────────
    Tour(
      id: 'chichen-itza-01',
      title: 'Chichen Itza',
      subtitle: 'Wonders of the Ancient Maya',
      description:
          'Explore one of the New Seven Wonders of the World through an immersive audio guide. '
          'Walk in the footsteps of the ancient Maya as our expert narration brings the sacred city '
          'of Chichen Itza to life. Discover the mysteries of El Castillo pyramid, the Great Ball Court, '
          'and the Temple of the Warriors — all at your own pace.',
      imageUrl:
          'https://images.unsplash.com/photo-1518638150340-f706e86654de?w=800&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1518638150340-f706e86654de?w=600&q=80',
        'https://images.unsplash.com/photo-1569650998742-af3e0c98cd14?w=600&q=80',
        'https://images.unsplash.com/photo-1585208798174-6cedd86e019a?w=600&q=80',
        'https://images.unsplash.com/photo-1548778052-311f4bc2b502?w=600&q=80',
      ],
      durationHours: 3.5,
      distanceKm: 2.8,
      difficulty: TourDifficulty.easy,
      category: TourCategory.archaeological,
      languages: [TourLanguage.english, TourLanguage.spanish],
      rating: 4.9,
      reviewCount: 2847,
      price: 0,
      isDownloaded: false,
      isFeatured: true,
      region: 'Yucatan State',
      highlights: [
        'El Castillo (Temple of Kukulcan)',
        'Great Ball Court — largest in Mesoamerica',
        'Temple of the Warriors',
        'Sacred Cenote',
        'El Caracol Observatory',
      ],
      audioNarrator: 'Dr. Maria Gonzalez',
      isOfflineAvailable: true,
      downloadsCount: 48200,
      startPoint: const LatLng(20.6843, -88.5678),
      routePoints: const [
        LatLng(20.6820, -88.5700),
        LatLng(20.6827, -88.5692),
        LatLng(20.6835, -88.5682),
        LatLng(20.6843, -88.5678),
        LatLng(20.6851, -88.5672),
        LatLng(20.6860, -88.5668),
        LatLng(20.6868, -88.5655),
        LatLng(20.6875, -88.5645),
        LatLng(20.6865, -88.5635),
        LatLng(20.6855, -88.5640),
        LatLng(20.6845, -88.5650),
        LatLng(20.6838, -88.5660),
      ],
      pois: const [
        PointOfInterest(
          id: 'ci-poi-01',
          name: 'El Castillo – Temple of Kukulcan',
          shortDescription: 'The iconic step pyramid, heart of Chichen Itza.',
          fullDescription:
              'El Castillo, also known as the Temple of Kukulcan, is the dominant structure '
              'at Chichen Itza. This magnificent step pyramid stands 30 meters tall and was built '
              'between the 9th and 12th centuries. During the spring and autumn equinoxes, the '
              'setting sun casts a shadow that creates the illusion of a serpent descending the '
              'pyramid\'s northern staircase — a breathtaking astronomical phenomenon the Maya '
              'engineered with incredible precision.',
          imageUrl:
              'https://images.unsplash.com/photo-1518638150340-f706e86654de?w=600&q=80',
          location: LatLng(20.6843, -88.5678),
          type: POIType.temple,
          audioClipUrl: 'audio/chichen/castillo.mp3',
          audioDurationSeconds: 185,
          orderIndex: 0,
          isVisited: false,
          tags: ['UNESCO', 'New 7 Wonders', 'Pyramid', 'Maya'],
          historicalPeriod: '800–1200 CE',
          funFact:
              'The pyramid has 365 steps — one for each day of the Maya solar calendar.',
        ),
        PointOfInterest(
          id: 'ci-poi-02',
          name: 'Great Ball Court',
          shortDescription: 'The largest ball court in ancient Mesoamerica.',
          fullDescription:
              'Stretching 168 meters long and 70 meters wide, the Great Ball Court is the '
              'largest pre-Columbian ball court ever found. The stone rings mounted on the walls '
              'were used in a ritual game where players had to pass a rubber ball through them '
              'using only their hips, elbows, and knees. The acoustic properties of the court '
              'are remarkable — a whisper at one end can be heard clearly at the other.',
          imageUrl:
              'https://images.unsplash.com/photo-1569650998742-af3e0c98cd14?w=600&q=80',
          location: LatLng(20.6851, -88.5672),
          type: POIType.monument,
          audioClipUrl: 'audio/chichen/ball_court.mp3',
          audioDurationSeconds: 210,
          orderIndex: 1,
          isVisited: false,
          tags: ['Sports', 'Ritual', 'Architecture'],
          historicalPeriod: '900–1200 CE',
          funFact:
              'The game was sometimes tied to human sacrifice, though historians debate whether it was the winners or losers who were sacrificed.',
        ),
        PointOfInterest(
          id: 'ci-poi-03',
          name: 'Temple of the Warriors',
          shortDescription: 'A grand temple surrounded by a forest of columns.',
          fullDescription:
              'The Temple of the Warriors is a large stepped pyramid flanked by rows of '
              'carved columns depicting warriors. At its summit sits a Chac Mool figure — a '
              'reclining deity holding a plate used for offerings. The "Group of a Thousand Columns" '
              'to the south once supported a vast roof structure, suggesting a large marketplace '
              'or administrative area.',
          imageUrl:
              'https://images.unsplash.com/photo-1585208798174-6cedd86e019a?w=600&q=80',
          location: LatLng(20.6860, -88.5668),
          type: POIType.temple,
          audioClipUrl: 'audio/chichen/warriors.mp3',
          audioDurationSeconds: 165,
          orderIndex: 2,
          isVisited: false,
          tags: ['Temple', 'Columns', 'Chac Mool'],
          historicalPeriod: '1000–1200 CE',
          funFact: 'This temple was built over an older structure called the Temple of Chac Mool.',
        ),
        PointOfInterest(
          id: 'ci-poi-04',
          name: 'Sacred Cenote',
          shortDescription: 'The sacred sinkhole where offerings were made to the rain god.',
          fullDescription:
              'The Sacred Cenote (Cenote Sagrado) is a natural sinkhole 60 meters in diameter '
              'and about 27 meters deep. It was used as a place of worship and sacrifice to Chaac, '
              'the Maya rain god. Archaeologists have recovered gold, jade, pottery, incense, and '
              'human remains from its depths — evidence of the importance of this site in Maya '
              'religion and ritual.',
          imageUrl:
              'https://images.unsplash.com/photo-1548778052-311f4bc2b502?w=600&q=80',
          location: LatLng(20.6875, -88.5645),
          type: POIType.cenote,
          audioClipUrl: 'audio/chichen/cenote.mp3',
          audioDurationSeconds: 145,
          orderIndex: 3,
          isVisited: false,
          tags: ['Cenote', 'Sacrifice', 'Ritual', 'Water'],
          historicalPeriod: '600–1200 CE',
          funFact:
              'Over 200 human skeletons have been found in the cenote, many belonging to children.',
        ),
        PointOfInterest(
          id: 'ci-poi-05',
          name: 'El Caracol Observatory',
          shortDescription: 'Ancient Maya astronomical observatory.',
          fullDescription:
              'El Caracol (meaning "snail" in Spanish, for its spiral interior staircase) is '
              'believed to have been an astronomical observatory. Its windows align precisely with '
              'the rising and setting points of Venus at specific times of year, demonstrating the '
              'Maya\'s advanced understanding of astronomy. The Maya tracked Venus with incredible '
              'accuracy, as the planet played a central role in their religious calendar.',
          imageUrl:
              'https://images.unsplash.com/photo-1518638150340-f706e86654de?w=600&q=80',
          location: LatLng(20.6838, -88.5660),
          type: POIType.monument,
          audioClipUrl: 'audio/chichen/caracol.mp3',
          audioDurationSeconds: 155,
          orderIndex: 4,
          isVisited: false,
          tags: ['Observatory', 'Astronomy', 'Venus', 'Maya Science'],
          historicalPeriod: '906 CE',
          funFact:
              'The Maya calendar was so accurate it differed from modern calculations by only 0.0001 days per year.',
        ),
      ],
    ),

    // ─────────────────────────────────────────────────────
    // TOUR 2 – TULUM ARCHAEOLOGICAL ZONE
    // ─────────────────────────────────────────────────────
    Tour(
      id: 'tulum-ruins-02',
      title: 'Tulum Ruins',
      subtitle: 'Maya City on the Caribbean Cliff',
      description:
          'Perched dramatically on a 12-meter cliff overlooking the turquoise Caribbean Sea, '
          'Tulum is one of the best-preserved coastal Maya sites. This audio tour guides you '
          'through the walled city\'s temples, palaces, and sacred spaces while revealing the '
          'rich history of this late Maya port city that thrived as a major trading hub.',
      imageUrl:
          'https://images.unsplash.com/photo-1570651046888-9a8e0e3ee47e?w=800&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1570651046888-9a8e0e3ee47e?w=600&q=80',
        'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=600&q=80',
        'https://images.unsplash.com/photo-1602524813831-3f6e5fbabd47?w=600&q=80',
        'https://images.unsplash.com/photo-1566438480900-0609be27a4be?w=600&q=80',
      ],
      durationHours: 2.0,
      distanceKm: 1.5,
      difficulty: TourDifficulty.easy,
      category: TourCategory.archaeological,
      languages: [TourLanguage.english, TourLanguage.spanish, TourLanguage.french],
      rating: 4.7,
      reviewCount: 1923,
      price: 0,
      isDownloaded: false,
      isFeatured: true,
      region: 'Quintana Roo',
      highlights: [
        'El Castillo above the sea cliffs',
        'Temple of the Descending God',
        'House of the Columns',
        'Stunning Caribbean Sea views',
        'Ancient city walls',
      ],
      audioNarrator: 'Carlos Mendoza',
      isOfflineAvailable: true,
      downloadsCount: 31500,
      startPoint: const LatLng(20.2104, -87.4296),
      routePoints: const [
        LatLng(20.2104, -87.4296),
        LatLng(20.2108, -87.4290),
        LatLng(20.2114, -87.4285),
        LatLng(20.2120, -87.4280),
        LatLng(20.2128, -87.4274),
        LatLng(20.2133, -87.4268),
        LatLng(20.2140, -87.4263),
        LatLng(20.2145, -87.4258),
      ],
      pois: const [
        PointOfInterest(
          id: 'tul-poi-01',
          name: 'El Castillo',
          shortDescription: 'The main pyramid, a lighthouse for ancient mariners.',
          fullDescription:
              'The imposing El Castillo at Tulum served as both a ceremonial center and a '
              'lighthouse. Its windows were strategically placed so that torches inside would '
              'create a light pattern visible from the sea, guiding Maya canoes through a gap '
              'in the barrier reef. The temple crowning the pyramid shows carvings of the '
              'Descending God, a deity associated with bees, honey, and Venus.',
          imageUrl:
              'https://images.unsplash.com/photo-1570651046888-9a8e0e3ee47e?w=600&q=80',
          location: LatLng(20.2120, -87.4280),
          type: POIType.temple,
          audioClipUrl: 'audio/tulum/castillo.mp3',
          audioDurationSeconds: 170,
          orderIndex: 0,
          isVisited: false,
          tags: ['Lighthouse', 'Pyramid', 'Sea View', 'Maya'],
          historicalPeriod: '1200–1521 CE',
          funFact: 'Tulum was still inhabited when the Spanish arrived in 1518.',
        ),
        PointOfInterest(
          id: 'tul-poi-02',
          name: 'Temple of the Descending God',
          shortDescription: 'A unique temple with an upside-down deity figure.',
          fullDescription:
              'This small but fascinating temple is named for the unusual figure carved '
              'above its doorway — a figure shown descending from the sky, head down and legs '
              'up. Scholars believe this represents the setting sun, Venus as the evening star, '
              'or the Bee God, who was especially important in this honey-producing region. '
              'Similar figures appear at several other Tulum buildings.',
          imageUrl:
              'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=600&q=80',
          location: LatLng(20.2128, -87.4274),
          type: POIType.temple,
          audioClipUrl: 'audio/tulum/descending.mp3',
          audioDurationSeconds: 130,
          orderIndex: 1,
          isVisited: false,
          tags: ['Relief', 'Deity', 'Unique Architecture'],
          historicalPeriod: '1200–1400 CE',
          funFact: 'The descending god motif is unique to the east coast of the Yucatan.',
        ),
        PointOfInterest(
          id: 'tul-poi-03',
          name: 'Cliff Viewpoint',
          shortDescription: 'Panoramic view over the Caribbean Sea.',
          fullDescription:
              'This breathtaking viewpoint sits at the edge of the 12-meter limestone cliff '
              'that Tulum is built upon. From here you can see the full turquoise expanse of the '
              'Caribbean, the reef barrier that protected Maya canoes, and the white sand beach '
              'below. On clear days you can spot sea turtles in the crystal-clear waters. '
              'This is the most photographed spot in the Yucatan Peninsula.',
          imageUrl:
              'https://images.unsplash.com/photo-1602524813831-3f6e5fbabd47?w=600&q=80',
          location: LatLng(20.2133, -87.4268),
          type: POIType.viewpoint,
          audioClipUrl: 'audio/tulum/viewpoint.mp3',
          audioDurationSeconds: 95,
          orderIndex: 2,
          isVisited: false,
          tags: ['View', 'Caribbean', 'Photography', 'Scenic'],
          funFact:
              'Tulum means "wall" or "fence" in Yucatec Maya, referring to its defensive walls.',
        ),
      ],
    ),

    // ─────────────────────────────────────────────────────
    // TOUR 3 – CENOTES ROUTE
    // ─────────────────────────────────────────────────────
    Tour(
      id: 'cenotes-route-03',
      title: 'Sacred Cenotes Route',
      subtitle: 'Underground Worlds of the Maya',
      description:
          'The Yucatan Peninsula is home to the world\'s largest underground river system, '
          'dotted with thousands of cenotes — sacred sinkholes that were portals to the underworld '
          'for the ancient Maya. This tour takes you through four stunning cenotes, combining '
          'natural wonder with deep cultural significance.',
      imageUrl:
          'https://images.unsplash.com/photo-1552070897-bd7a19f0f3de?w=800&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1552070897-bd7a19f0f3de?w=600&q=80',
        'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?w=600&q=80',
        'https://images.unsplash.com/photo-1600706432502-77a0e2e32790?w=600&q=80',
        'https://images.unsplash.com/photo-1518638150340-f706e86654de?w=600&q=80',
      ],
      durationHours: 4.5,
      distanceKm: 18.0,
      difficulty: TourDifficulty.moderate,
      category: TourCategory.cenotes,
      languages: [TourLanguage.english, TourLanguage.spanish],
      rating: 4.8,
      reviewCount: 1456,
      price: 25,
      isDownloaded: false,
      isFeatured: false,
      region: 'Quintana Roo',
      highlights: [
        'Cenote Ik Kil – open-air paradise',
        'Cenote Samula – stalactite cave',
        'Gran Cenote – snorkeling spot',
        'Cenote Dos Ojos – diving site',
        'Maya legends and lore',
      ],
      audioNarrator: 'Sofia Ramirez',
      isOfflineAvailable: true,
      downloadsCount: 22100,
      startPoint: const LatLng(20.6796, -88.5139),
      routePoints: const [
        LatLng(20.6796, -88.5139),
        LatLng(20.6700, -88.4900),
        LatLng(20.5500, -88.2300),
        LatLng(20.3500, -87.7200),
        LatLng(20.2800, -87.5500),
      ],
      pois: const [
        PointOfInterest(
          id: 'cen-poi-01',
          name: 'Cenote Ik Kil',
          shortDescription: 'The stunning open-air cenote near Chichen Itza.',
          fullDescription:
              'Cenote Ik Kil is arguably the most beautiful cenote in the Yucatan. '
              'This open-air sinkhole is 60 meters in diameter and 26 meters deep, with crystal-clear '
              'blue water surrounded by hanging vines, ferns, and small waterfalls. The Maya considered '
              'it sacred and used it for ritual ceremonies and offerings to Chaac. Today it\'s a '
              'popular swimming spot where you can plunge into its refreshing waters.',
          imageUrl:
              'https://images.unsplash.com/photo-1552070897-bd7a19f0f3de?w=600&q=80',
          location: LatLng(20.6796, -88.5139),
          type: POIType.cenote,
          audioClipUrl: 'audio/cenotes/ik_kil.mp3',
          audioDurationSeconds: 155,
          orderIndex: 0,
          isVisited: false,
          tags: ['Swimming', 'Open-air', 'Sacred', 'Photography'],
          funFact:
              '"Ik Kil" means "place of the winds" in Yucatec Maya.',
        ),
        PointOfInterest(
          id: 'cen-poi-02',
          name: 'Cenote Samula',
          shortDescription: 'A magical underground cave cenote with stalactites.',
          fullDescription:
              'Cenote Samula is a semi-open cenote where ancient stalactites hang dramatically '
              'from the cave ceiling, reaching toward the water below. A massive tree grows at the '
              'rim and sends its roots down through the 30 meters of rock to reach the water — a '
              'striking natural phenomenon. The cenote is named after the Samula tree, considered '
              'sacred by the Maya.',
          imageUrl:
              'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?w=600&q=80',
          location: LatLng(20.5500, -88.2300),
          type: POIType.cenote,
          audioClipUrl: 'audio/cenotes/samula.mp3',
          audioDurationSeconds: 135,
          orderIndex: 1,
          isVisited: false,
          tags: ['Cave', 'Stalactites', 'Swimming', 'Underground'],
          funFact:
              'The tree roots you see descending into the water are from a Samula tree over 100 years old.',
        ),
        PointOfInterest(
          id: 'cen-poi-03',
          name: 'Gran Cenote',
          shortDescription: 'Premier snorkeling spot with crystal-clear waters.',
          fullDescription:
              'Gran Cenote is a semi-open cenote system near Tulum, beloved by snorkelers '
              'and divers for its exceptionally clear water and abundant marine life. The cenote '
              'connects to the vast underground river system (Sistema Sac Actun), the longest '
              'underwater cave system in the world at over 347 km. Turtles are frequently spotted '
              'here, and the cave sections feature impressive stalactite and stalagmite formations.',
          imageUrl:
              'https://images.unsplash.com/photo-1600706432502-77a0e2e32790?w=600&q=80',
          location: LatLng(20.2800, -87.5500),
          type: POIType.cenote,
          audioClipUrl: 'audio/cenotes/gran_cenote.mp3',
          audioDurationSeconds: 165,
          orderIndex: 2,
          isVisited: false,
          tags: ['Snorkeling', 'Turtles', 'Cave Diving', 'Underground River'],
          funFact:
              'Gran Cenote connects to the longest underwater cave system in the world.',
        ),
      ],
    ),

    // ─────────────────────────────────────────────────────
    // TOUR 4 – MERIDA CITY TOUR
    // ─────────────────────────────────────────────────────
    Tour(
      id: 'merida-city-04',
      title: 'Merida Historic Center',
      subtitle: 'The White City of the Maya World',
      description:
          'Merida, the capital of Yucatan State, is a vibrant city where colonial Spanish '
          'architecture meets living Maya culture. Known as "La Ciudad Blanca" (The White City), '
          'its historic center is a UNESCO candidate with stunning cathedrals, colorful plazas, '
          'and a culinary scene unlike anywhere else in Mexico.',
      imageUrl:
          'https://images.unsplash.com/photo-1518638150340-f706e86654de?w=800&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1518638150340-f706e86654de?w=600&q=80',
        'https://images.unsplash.com/photo-1569650998742-af3e0c98cd14?w=600&q=80',
        'https://images.unsplash.com/photo-1585208798174-6cedd86e019a?w=600&q=80',
        'https://images.unsplash.com/photo-1548778052-311f4bc2b502?w=600&q=80',
      ],
      durationHours: 2.5,
      distanceKm: 3.2,
      difficulty: TourDifficulty.easy,
      category: TourCategory.city,
      languages: [TourLanguage.english, TourLanguage.spanish, TourLanguage.german],
      rating: 4.6,
      reviewCount: 876,
      price: 0,
      isDownloaded: false,
      isFeatured: false,
      region: 'Yucatan State',
      highlights: [
        'Cathedral of Merida (1598)',
        'Paseo de Montejo boulevard',
        'Lucas de Galvez Market',
        'Casa de Montejo',
        'Gran Museo del Mundo Maya',
      ],
      audioNarrator: 'Ana Luisa Perez',
      isOfflineAvailable: false,
      downloadsCount: 14300,
      startPoint: const LatLng(20.9674, -89.6237),
      routePoints: const [
        LatLng(20.9674, -89.6237),
        LatLng(20.9680, -89.6230),
        LatLng(20.9688, -89.6222),
        LatLng(20.9695, -89.6215),
        LatLng(20.9702, -89.6208),
        LatLng(20.9710, -89.6200),
        LatLng(20.9718, -89.6192),
        LatLng(20.9725, -89.6185),
      ],
      pois: const [
        PointOfInterest(
          id: 'mer-poi-01',
          name: 'Plaza Grande',
          shortDescription: 'The main square and heart of Merida.',
          fullDescription:
              'Plaza Grande is the historic heart of Merida, surrounded by the Cathedral, '
              'the Palacio Municipal, and the Palacio de Gobierno. Built on the ruins of the Maya '
              'city of T\'ho, this plaza has been the center of Merida\'s civic and cultural life '
              'for nearly 500 years. On Sunday evenings it comes alive with traditional Jarana dancing, '
              'music, and the famous "Beso Merideo" (Merida Kiss) event.',
          imageUrl:
              'https://images.unsplash.com/photo-1518638150340-f706e86654de?w=600&q=80',
          location: LatLng(20.9674, -89.6237),
          type: POIType.monument,
          audioClipUrl: 'audio/merida/plaza.mp3',
          audioDurationSeconds: 125,
          orderIndex: 0,
          isVisited: false,
          tags: ['Colonial', 'Plaza', 'Dancing', 'Culture'],
          historicalPeriod: '1542 CE',
          funFact: 'Merida was founded on January 6, 1542 by Francisco de Montejo the Younger.',
        ),
        PointOfInterest(
          id: 'mer-poi-02',
          name: 'Cathedral of San Ildefonso',
          shortDescription: 'The oldest cathedral on the American mainland.',
          fullDescription:
              'The Cathedral of San Ildefonso in Merida is considered the oldest completed '
              'cathedral on the American mainland, begun in 1561 and completed in 1598. Its stones '
              'came from the nearby Maya city of T\'ho, and many of its original artworks were '
              'burned during the Mexican Revolution in 1915. Inside, the Christ of the Blisters — '
              'a charred figure carved from wood that survived a fire — is the most revered object.',
          imageUrl:
              'https://images.unsplash.com/photo-1569650998742-af3e0c98cd14?w=600&q=80',
          location: LatLng(20.9680, -89.6230),
          type: POIType.monument,
          audioClipUrl: 'audio/merida/cathedral.mp3',
          audioDurationSeconds: 148,
          orderIndex: 1,
          isVisited: false,
          tags: ['Cathedral', 'Colonial', 'Religion', 'History'],
          historicalPeriod: '1561–1598 CE',
          funFact: 'Built with stones taken from the Maya temple pyramid that once stood here.',
        ),
        PointOfInterest(
          id: 'mer-poi-03',
          name: 'Paseo de Montejo',
          shortDescription: 'The grand boulevard of Merida\'s golden age.',
          fullDescription:
              'Modeled after Paris\'s Champs-Élysées, Paseo de Montejo was built during the '
              'Yucatan\'s henequen (sisal) boom in the late 19th century. Wealthy henequen '
              'plantation owners built opulent mansions along this tree-lined boulevard, many of '
              'which are now museums, banks, and restaurants. The street stretches 2 km north '
              'from the historic center and is lined with beautiful European-influenced architecture.',
          imageUrl:
              'https://images.unsplash.com/photo-1585208798174-6cedd86e019a?w=600&q=80',
          location: LatLng(20.9710, -89.6200),
          type: POIType.viewpoint,
          audioClipUrl: 'audio/merida/paseo.mp3',
          audioDurationSeconds: 140,
          orderIndex: 2,
          isVisited: false,
          tags: ['Boulevard', 'Colonial Mansions', 'Architecture', 'Walking'],
          historicalPeriod: '1890s',
          funFact:
              'During the henequen boom, Merida had more millionaires per capita than any other city in the world.',
        ),
        PointOfInterest(
          id: 'mer-poi-04',
          name: 'Lucas de Galvez Market',
          shortDescription: 'The vibrant heart of Yucatecan gastronomy.',
          fullDescription:
              'The Lucas de Galvez Market is Merida\'s main public market and a feast for all '
              'the senses. Here you\'ll find traditional Yucatecan foods like cochinita pibil, '
              'papadzules, sopa de lima, and panuchos. Browse stalls selling handwoven hammocks, '
              'traditional huipiles, local ceramics, and tropical fruits you won\'t find anywhere '
              'else. The market has operated on this site since the 19th century.',
          imageUrl:
              'https://images.unsplash.com/photo-1548778052-311f4bc2b502?w=600&q=80',
          location: LatLng(20.9695, -89.6215),
          type: POIType.market,
          audioClipUrl: 'audio/merida/market.mp3',
          audioDurationSeconds: 120,
          orderIndex: 3,
          isVisited: false,
          tags: ['Food', 'Market', 'Crafts', 'Local Culture'],
          funFact: 'Yucatecan cuisine is recognized by UNESCO as an Intangible Cultural Heritage.',
        ),
      ],
    ),

    // ─────────────────────────────────────────────────────
    // TOUR 5 – UXMAL
    // ─────────────────────────────────────────────────────
    Tour(
      id: 'uxmal-05',
      title: 'Uxmal',
      subtitle: 'Puuc Hills Maya Masterpiece',
      description:
          'Often overshadowed by Chichen Itza but arguably more architecturally refined, '
          'Uxmal is a UNESCO World Heritage Site and one of the finest examples of Pure Puuc '
          'Maya architecture. Its intricate mosaic facades, magnificent pyramids, and well-preserved '
          'palaces make it a must-see for any serious archaeology enthusiast.',
      imageUrl:
          'https://images.unsplash.com/photo-1569650998742-af3e0c98cd14?w=800&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1569650998742-af3e0c98cd14?w=600&q=80',
        'https://images.unsplash.com/photo-1518638150340-f706e86654de?w=600&q=80',
        'https://images.unsplash.com/photo-1585208798174-6cedd86e019a?w=600&q=80',
      ],
      durationHours: 3.0,
      distanceKm: 2.2,
      difficulty: TourDifficulty.moderate,
      category: TourCategory.archaeological,
      languages: [TourLanguage.english, TourLanguage.spanish],
      rating: 4.8,
      reviewCount: 1134,
      price: 0,
      isDownloaded: false,
      isFeatured: false,
      region: 'Yucatan State',
      highlights: [
        'Pyramid of the Magician',
        'Governor\'s Palace',
        'Nunnery Quadrangle',
        'Great Pyramid',
        'Intricate Puuc-style mosaics',
      ],
      audioNarrator: 'Dr. Roberto Chan',
      isOfflineAvailable: true,
      downloadsCount: 18700,
      startPoint: const LatLng(20.3595, -89.7713),
      routePoints: const [
        LatLng(20.3595, -89.7713),
        LatLng(20.3602, -89.7705),
        LatLng(20.3610, -89.7698),
        LatLng(20.3618, -89.7690),
        LatLng(20.3625, -89.7682),
        LatLng(20.3615, -89.7675),
        LatLng(20.3608, -89.7680),
      ],
      pois: const [
        PointOfInterest(
          id: 'uxm-poi-01',
          name: 'Pyramid of the Magician',
          shortDescription: 'A unique oval-base pyramid with a legendary origin story.',
          fullDescription:
              'The Pyramid of the Magician is unique among Maya pyramids for its unusual '
              'oval base — all others are rectangular. According to legend, the pyramid was '
              'built in a single night by a dwarf magician hatched from an egg. In reality, '
              'it was built in five construction phases over several centuries. At 35 meters, '
              'it is the tallest structure at Uxmal and offers panoramic views of the surrounding '
              'Puuc hills.',
          imageUrl:
              'https://images.unsplash.com/photo-1569650998742-af3e0c98cd14?w=600&q=80',
          location: LatLng(20.3595, -89.7713),
          type: POIType.temple,
          audioClipUrl: 'audio/uxmal/pyramid.mp3',
          audioDurationSeconds: 178,
          orderIndex: 0,
          isVisited: false,
          tags: ['Oval Pyramid', 'Legend', 'Puuc Style', 'UNESCO'],
          historicalPeriod: '600–900 CE',
          funFact: 'The pyramid was built in 5 stages over several centuries.',
        ),
        PointOfInterest(
          id: 'uxm-poi-02',
          name: 'Governor\'s Palace',
          shortDescription: 'A masterpiece of Maya architecture with 20,000 mosaic stones.',
          fullDescription:
              'The Governor\'s Palace at Uxmal is considered by many scholars to be the '
              'single most spectacular building in pre-Columbian Mesoamerica. Its 97-meter-long '
              'facade is decorated with approximately 20,000 intricately carved stone mosaic '
              'pieces. The building\'s alignment is oriented precisely toward Venus\'s southernmost '
              'rising point, reflecting the Maya\'s sophisticated astronomical knowledge.',
          imageUrl:
              'https://images.unsplash.com/photo-1518638150340-f706e86654de?w=600&q=80',
          location: LatLng(20.3618, -89.7690),
          type: POIType.monument,
          audioClipUrl: 'audio/uxmal/governors.mp3',
          audioDurationSeconds: 190,
          orderIndex: 1,
          isVisited: false,
          tags: ['Architecture', 'Mosaic', 'Venus', 'Masterpiece'],
          historicalPeriod: '900–1000 CE',
          funFact: 'The facade contains over 20,000 individually carved stone pieces.',
        ),
      ],
    ),
  ];

  // Helper getters
  static List<Tour> get featuredTours => tours.where((t) => t.isFeatured).toList();

  static List<Tour> getToursByCategory(TourCategory category) =>
      tours.where((t) => t.category == category).toList();

  static List<Tour> get freeTours => tours.where((t) => t.price == 0).toList();

  static List<Tour> searchTours(String query) {
    final q = query.toLowerCase();
    return tours.where((t) =>
        t.title.toLowerCase().contains(q) ||
        t.subtitle.toLowerCase().contains(q) ||
        t.region.toLowerCase().contains(q) ||
        t.description.toLowerCase().contains(q)).toList();
  }

  // Categories with display info
  static const List<Map<String, dynamic>> categories = [
    {'label': 'All', 'icon': '🗺️', 'value': null},
    {'label': 'Archaeological', 'icon': '🏛️', 'value': TourCategory.archaeological},
    {'label': 'Cenotes', 'icon': '💧', 'value': TourCategory.cenotes},
    {'label': 'City Tour', 'icon': '🏙️', 'value': TourCategory.city},
    {'label': 'Nature', 'icon': '🌿', 'value': TourCategory.nature},
    {'label': 'Cultural', 'icon': '🎭', 'value': TourCategory.cultural},
  ];
}

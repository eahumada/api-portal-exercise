module.exports = (schema, sequelize, type) => {
    return sequelize.define('person', {
        id: { type: type.SMALLINT, primaryKey: true, autoIncrement: true },
        nationalId: { type: type.STRING(10), field: 'national_id', unique: true },
        name: { type: type.STRING(20) },
        lastName: { type: type.STRING(30), field: 'last_name' },
        age: { type: type.SMALLINT },
        originPlanet: { type: type.STRING(20), field: 'origin_planet' },
        pictureUrl: { type: type.STRING(2083), field: 'picture_url' }
    },
    {
        schema: schema,
        timestamps: false,
        tableName: 'person'
    })
}
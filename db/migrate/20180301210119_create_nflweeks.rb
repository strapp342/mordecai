class CreateNflweeks < ActiveRecord::Migration[5.1]
  def change
    create_table :nflweeks do |t|
      t.string :w
      t.string :y
      t.string :t
      t.string :gd
      t.string :bph

      t.timestamps
    end

    create_table :nflgames do |t|
      t.string :eid
      t.string :gsis
      t.string :d
      t.string :t
      t.string :q
      t.string :h
      t.string :hnn
      t.string :hs
      t.string :v
      t.string :vnn
      t.string :vs
      t.string :rz
      t.string :ga
      t.string :gt

      t.belongs_to :nflweek, index: true

      t.timestamps
    end
  end
end

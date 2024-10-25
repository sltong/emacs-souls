;;; souls.el --- A Souls-like tutorial game -*- coding: utf-8; lexical-binding: t; -*-

;; Copyright (C) 2024 λαω

;; Author: λαω <lambda.alpha.omega@proton.me>
;; Maintainer: λαω <lambda.alpha.omega@proton.me>
;; URL: https://escritoire.software/emacs-souls
;; Version: 0.1.0
;; Package-Requires: ((emacs "29.1")
;;                    (cl-lib "1.0")
;;                    (eieio "1.4"))
;; Keywords: games multimedia help

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU Affero General Public License
;; as published by the Free Software Foundation, either version 3 of
;; the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; Affero General Public License for more details.

;; You should have received a copy of the GNU Affero General Public
;; License along with this program. If not, see
;; <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Souls is a edifying game inspired by FromSoftware's "Dark Souls"
;; video game franchise.

;; It provides a major mode, `souls-mode'.

;; It is strongly recommended that Souls is run in a separate instance
;; of Emacs, with a different `user-emacs-directory' and
;; `user-init-file' from one's usual setup. Souls makes extreme
;; changes to Emacs core functionality.

;; Local Variables:
;; read-symbol-shorthands: (("s-" . "souls-"))
;; End:

;;; Code:

;;; Requirements
(require 'cl-lib)
(require 'eieio)
;; (require 'gv)
;; (require 'extmap)

;;; Customizations
(defgroup souls nil
  "Prepare to Vi."
  :link '(info-link :tag "Info Manual" "(souls)")
  :link '(url-link :tag "Website" "https://github.com/sltong/emacs-souls")
  :group 'games
  :group 'help
  :prefix "souls-")

;; Faces
(defgroup souls-faces nil "Souls faces." :group 'souls :group 'faces)

(defface souls-you-died
  '((t :background "black" :foreground "#731D1E" :height 2.0 :weight bold))
  "Face used for the \"YOU DIED\" screen.")

(defface souls-health-bar-depleted
  '((t :foreground "#0d0e0d"))
  "Face used for depleted player health.")

(defface souls-health-bar-remaining
  '((t :background "#0d0e0d" :foreground "#480907"))
  "Face used for remaining player health.")

(defface souls-health-bar-damage
  '((t :foreground "#5c5a1d"))
  "Face used for health bar damage taken.")

(defface souls-stamina-bar-depleted
  '((t :foreground "#0d0e0d"))
  "Face used for depleted player stamina.")

(defface souls-stamina-bar-remaining
  '((t :background "#0d0e0d" :foreground "#314f3f"))
  "Face used for remaining player stamina.")

;;; classes and their methods
(defclass souls-base-class ()
  ((name :initarg :name
         :initform ""
         :type string
         :documentation "The name of a Souls object.")
   (description :initarg :description
                :initform ""
                :type string
                :documentation "The description of a Souls object."))
  "An abstract base class for Souls objects."
  :abstract t)

;; item classes and methods
(defclass souls-item (souls-base-class)
  ((usable :initarg :usable
           :initform nil
           :type boolean
           :documentation "The usability of an item."))
  "An abstract base class for items."
  :abstract t)

(defclass souls-consumable-item (souls-item)
  ((quantity :initarg :quantity
             :initform 0
             :type integer
             :documentation "The quantity of a consumable item."))
  "A class for consumable items.")

(defclass souls-weapon ()
  ((physical-damage :initarg :physical-damage
                    :initform 0
                    :type (integer 0 *)
                    :documentation "The physical damage of a weapon."))
"A class for Souls weapons.")

;; TODO
;; (defclass souls-equipment (souls-base-class)
;;   (())
;;   "A class for equipment.")

;; character classes and methods
(defclass souls-character (souls-base-class)
  ((hp :initarg :hp
       :initform 0
       :type integer
       :documentation "Hit points of a Souls character.")
   (stamina :initarg :stamina
            :initform 0
            :type integer
            :documentation "Stamina of a Souls character.")
   )
  "An abstract base class for Souls characters."
  :abstract t)

(defclass souls-player-character (souls-character)
  ((hp :initarg :hp
       :initform 0
       :type integer
       :documentation "Hit points of a Souls character.")
   (stamina :initarg :stamina
            :initform 0
            :type integer
            :documentation "Stamina of a Souls character.")
   )
  "A class for the player character.")

;; weapons
(defvar souls-weapon-types '(straight-sword))

(defvar souls-weapons '((longsword . '(name "Longsword"
                                       description "Widely-used standard straight sword, only matched in ubiquity by the shortsword.
An accessible sword which inflicts consistent regular damage and high slash damage, making it applicable to a variety of situations."
                                       type straight-sword
                                       physical-damage 80))))


;;; Items
(defvar souls-item-types '(ammunition
                           consumables
                           embers
                           key-consfire-items
                           keys
                           multiplayer
                           ore
                           projectiles
                           souls
                           tools
                           unequippable))


;; QUESTION: should there be a `souls' keymap distinct from `souls-mode-map'?
;; (defvar-keymap souls-map
;;   :doc "Souls keymap.")

(defcustom souls-player-save-file nil
  "Souls player's save file."
  :type '(file)
  :group 'souls)

;;; Character
(defgroup souls-player-character nil "Souls player character." :group 'souls)

(defcustom souls-player-character-name nil
  "Player character name."
  :type '(string)
  :group 'souls-player-character)

;; TODO
(defcustom souls-player-character-gender-expression nil
  "Player character gender expression."
  :type '(symbol)
  :group 'souls-player-character)

;; TODO
(defcustom souls-player-character-physique nil
  "Player character physique."
  :type '(symbol)
  :group 'souls-player-character)

;; TODO
(defcustom souls-player-character-face nil
  "Player character face type."
  :type '(symbol)
  :group 'souls-player-character)

;; TODO
(defcustom souls-player-character-hair nil
  "Player character hair style."
  :type '(symbol)
  :group 'souls-player-character)

;; TODO
(defcustom souls-player-character-hair-color "black"
  "Player character hair color."
  :type '(color)
  :group 'souls-player-character)

(defconst souls-player-character-attributes '(level
                                       vitality
                                       attunement
                                       endurance
                                       strength
                                       dexterity
                                       resistance
                                       intelligence
                                       faith
                                       humanity))

;;; Character starting elements
(defconst souls-player-character-classes
  '((warrior . '(attributes '(level 4
                              vitality 11
                              attunement 14
                              endurance 12
                              strength 13
                              dexterity 13
                              resistance 11
                              intelligence 9
                              faith 9
                              humanity 0)
                 equipment '(weapon      longsword
                             shield      heater-shield
                             helm        standard-helm
                             chest-armor hard-leather-armor
                             gauntlets   hard-leather-gauntlets
                             leg-armor   hard-leather-boots)))
    (knight)
    (wanderer)
    (thief)
    (bandit)
    (hunter)
    (sorcerer)
    (pyromancer)
    (cleric)
    (deprived))
  "Player character classes.")

(defvar souls-player-character-class nil
  "Player character (starting) class.")
;; :type '(choice (const :tag "Warrior" warrior)
;;                ;; (const :tag "Knight" knight)
;;                ;; (const :tag "Wanderer" wanderer)
;;                ;; (const :tag "Thief" thief)
;;                ;; (const :tag "Bandit" bandit)
;;                ;; (const :tag "Hunter" hunter)
;;                ;; (const :tag "Sorcerer" sorcerer)
;;                ;; (const :tag "Pyromancer" pyromancer)
;;                ;; (const :tag "Cleric" cleric)
;;                ;; (const :tag "Deprived" deprived)
;;                )
;; :group 'souls-player-character)

;; Todo
;; (defcustom souls-player-character-gift nil
;;   "Player character starting gift."
;;   :type '(choice (const :tag "Goddess's Blessing" goddesss-blessing)
;;                  (const :tag "Black Firebomb" black-firebomb)
;;                  (const :tag "Twin Humanities" twin-humanities)
;;                  (const :tag "Binoculars" binoculars)
;;                  (const :tag "Pendant" pendant)
;;                  (const :tag "Master Key" master-key)
;;                  (const :tag "Tiny Being's Ring" tiny-beings-ring)
;;                  (const :tag "Old Witch's Ring" old-witchs-ring))
;;   :group 'souls-player-character)

;;; Minor mode
(define-derived-mode souls-mode
  special-mode "Souls"
  "Major mode for Souls."
  :group 'souls)

;;; Buffers
(defvar souls-menu-buffer "*Souls Menu*")

(defvar souls-firelink-bind-buffer "*Firelink Bind*")

(defvar souls-log-buffer "*Souls Log*")

(defvar souls-you-died-buffer "*YOU DIED*")

;; Buffer management
(defun souls--get-or-create-firelink-bind-buffer ()
  "Get or create the Firelink Bind buffer."
  (setq souls-firelink-bind-buffer (get-buffer-create "*Firelink Bind*"))
  (switch-to-buffer souls-firelink-bind-buffer)
  (delete-other-windows)
  (setq buffer-read-only t)
  nil)

(defun souls--get-or-create-you-died-buffer ()
  "Get or create the *YOU DIED* buffer."
  (setq souls-you-died-buffer (get-buffer-create "*YOU DIED*"))
  (switch-to-buffer souls-you-died-buffer)
  (delete-other-windows)
  (setq-local buffer-read-only nil)
  (erase-buffer)
  (buffer-face-set "souls-you-died")
  (let* ((text "YOU DIED")
         (line-count (count-lines (point-min) (point-max)))
         (middle-line (/ line-count 4))
         (max-height (window-height))  ;; Get the width of the current window
         (max-width (window-width))  ;; Get the width of the current window
         (text-length (length text))
         ;; Calculate padding lines needed for vertical centering
         (vertical-padding (max 0 (/ (- max-height middle-line) 4)))
         ;; Calculate padding spaces needed for horizontal centering
         (horizontal-padding (max 0 (/ (- max-width text-length) 4))))
    ;; Insert newlines for vertical centering
    (dotimes (_ vertical-padding)
      (insert "\n"))
    ;; Insert spaces for horizontal centering, followed by the text
    (insert (make-string horizontal-padding ?\s) text)
    (setq-local buffer-read-only t)))

;;; Defaults management functions
(defun unload-default-packages ()
  "Unload default packages."
  nil)

(defun unbind-default-key-bindings ()
  "Unbind default key bindings."
  nil)

(provide 'souls)
;;; souls.el ends here
